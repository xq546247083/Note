-- ============================================================
-- chat-to-db 插件建表脚本（MySQL 8.x）
-- 表结构可按你的需求自由调整，插件只依赖下面的列：
--   chat_session.session_id / chat_message.session_id / seq / role / content / raw
-- ============================================================

CREATE DATABASE IF NOT EXISTS dsh_chat DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dsh_chat;

-- 会话表：一个 DSH 对话 = 一行
CREATE TABLE IF NOT EXISTS chat_session (
  session_id   VARCHAR(64)  NOT NULL COMMENT 'DSH 会话 ID',
  title        VARCHAR(255) NULL     COMMENT '会话标题（DSH 自动生成）',
  workspace    VARCHAR(255) NULL     COMMENT '工作目录',
  created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (session_id)
) ENGINE = InnoDB COMMENT = 'DSH 会话';

-- 消息表：每条 user/assistant 消息 = 一行
CREATE TABLE IF NOT EXISTS chat_message (
  id           BIGINT       NOT NULL AUTO_INCREMENT,
  session_id   VARCHAR(64)  NOT NULL COMMENT '所属会话',
  seq          INT          NOT NULL COMMENT 'DSH 事件序号（同会话内严格递增，保证顺序）',
  role         VARCHAR(16)  NOT NULL COMMENT 'user / assistant',
  content      TEXT         NULL     COMMENT '提取出的纯文本内容',
  turn         INT          NULL     COMMENT '对话轮次',
  step         INT          NULL     COMMENT '轮内步骤',
  usage_tokens INT          NULL     COMMENT 'assistant 消息的 token 用量（若有）',
  raw          JSON         NULL     COMMENT 'DSH 原始事件完整数据（保真，可随时补字段）',
  created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_session_seq (session_id, seq),
  KEY idx_session (session_id)
) ENGINE = InnoDB COMMENT = 'DSH 聊天消息';
