/**
 * chat-to-db —— 把 DSH 聊天记录实时旁路写入你自己的 MySQL 数据库。
 *
 * 原理：监听 DSH 的 `session/event` 事件（每条 user/assistant 消息追加后触发，
 * post-commit、fire-and-forget，本插件失败不影响主流程），把消息写入自己的表。
 * 不动 DSH 默认的 jsonl 存储，风险最小。
 *
 * 安装：在 profile 的 cordis.patch.yml 加一行（参照 readme 顶部注释）：
 *
 *   - insert:
 *       - id: chat-to-db
 *         name: './plugins/chat-to-db'
 *         config:
 *           host: 127.0.0.1
 *           port: 3306
 *           user: root
 *           password: '你的密码'
 *           database: dsh_chat
 */
import type { Context } from '@deepseek-ai/cordis'
import mysql from 'mysql2/promise'

export const name = 'chat-to-db'

interface ChatToDbConfig {
  host: string
  port?: number
  user: string
  password: string
  database: string
  /** 表名前缀，默认 chat_（即 chat_session / chat_message） */
  tablePrefix?: string
}

interface SessionEvent {
  seq: number
  time: number
  type: string
  data: any
}

/** 从消息的 content blocks 里提取纯文本。 */
function extractText(content: unknown): string {
  if (!Array.isArray(content)) return ''
  return content
    .filter((block: any) => block?.type === 'text' && typeof block.text === 'string')
    .map((block: any) => block.text)
    .join('\n')
}

export function apply(ctx: Context, config: ChatToDbConfig): void {
  const cfg = config
  const prefix = cfg.tablePrefix ?? 'chat_'
  const sessionTable = `${prefix}session`
  const messageTable = `${prefix}message`

  const pool = mysql.createPool({
    host: cfg.host,
    port: cfg.port ?? 3306,
    user: cfg.user,
    password: cfg.password,
    database: cfg.database,
    connectionLimit: 3,
    waitForConnections: true,
    charset: 'utf8mb4',
  })

  /** 记录失败只告警，绝不抛给事件链。 */
  const warn = (err: unknown, what: string): void => {
    ctx.logger.warn(`chat-to-db: ${what} failed: ${err instanceof Error ? err.message : String(err)}`)
  }

  // 会话出现即建行（幂等 upsert；会话标题由 DSH 的 session-title 插件维护，这里暂存空值）
  ctx.on('session/created', (session) => {
    pool.execute(
      `INSERT INTO ${sessionTable} (session_id, title, workspace, created_at, updated_at)
       VALUES (?, ?, ?, NOW(), NOW())
       ON DUPLICATE KEY UPDATE updated_at = NOW()`,
      [session.id, null, session.header.cwd ?? null],
    ).catch(err => warn(err, 'session upsert'))
  })

  // 每条消息：提取文本 + 原样存 raw JSON
  ctx.on('session/event', (session, event: SessionEvent) => {
    if (event.type !== 'user/message' && event.type !== 'assistant/message') return

    const data = event.data
    // user/message 的 data 就是消息体；assistant/message 的 data 包了一层
    const message = event.type === 'user/message' ? data : data?.message
    if (!message) return

    const usage = data.usage
    const usageTokens = usage ? (usage.inputTokens ?? 0) + (usage.outputTokens ?? 0) : null

    pool.execute(
      `INSERT INTO ${messageTable}
         (session_id, seq, role, content, turn, step, usage_tokens, raw, created_at)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, FROM_UNIXTIME(? / 1000))`,
      [
        session.id,
        event.seq,
        message.role ?? event.type.split('/')[0],
        extractText(message.content),
        data.turn ?? null,
        data.step ?? null,
        usageTokens,
        JSON.stringify(event),
        event.time,
      ],
    ).catch(err => warn(err, `message insert (seq=${event.seq})`))
  })

  // 插件卸载时关闭连接池
  ctx.effect(() => () => { void pool.end() }, 'chat-to-db.pool')
}
