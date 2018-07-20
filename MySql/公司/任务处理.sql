DROP TABLE IF EXISTS tempZ; 
CREATE TABLE tempZ  SELECT ID , CONCAT(id,',',TaskSideGroup,',',ShowOrder) AS Str FROM  `model_dev`.`b_task_side_model`;
ALTER TABLE `tempZ` ADD PRIMARY KEY ( `ID` );

-- 任务处理 --
DROP PROCEDURE IF EXISTS fix_task_bug;
DELIMITER //

-- 创建存储过程 --
CREATE PROCEDURE fix_task_bug()
BEGIN -- 开始存储过程

DECLARE my_playerid CHAR (36); -- 自定义变量1
DECLARE my_CurrentTaskIDStr TEXT; -- 自定义变量2

-- 游标循环结束控制变量 --
DECLARE done BOOL DEFAULT FALSE;

-- 筛选出玩家卡死的建筑队列信息 --
DECLARE My_Cursor CURSOR FOR (SELECT PlayerID,CurrentTaskIDStr FROM `player_zbh`.`p_task_side_info` WHERE CurrentTaskIDStr NOT LIKE '%|%' AND CurrentTaskIDStr!="") ;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; -- 绑定控制变量到游标,游标循环结束自动转true  

OPEN My_Cursor; -- 打开游标 
  myLoop:LOOP -- 开始循环体,myLoop为自定义循环名,结束循环时用到 
    FETCH My_Cursor INTO my_playerid,my_CurrentTaskIDStr; -- 将游标当前读取行的数据顺序赋予自定义变量123
    IF done THEN
      LEAVE myLoop;
      END IF;
      
	UPDATE `p_task_side_info` SET CurrentTaskIDStr=
	(
		SELECT GROUP_CONCAT(Str SEPARATOR '|') FROM tempZ WHERE FIND_IN_SET(id,CurrentTaskIDStr)
	)
	WHERE playerid=my_playerid;

  END LOOP myLoop; -- 结束循环

  CLOSE My_Cursor; -- 关闭游标

END; -- 结束存储过程

//
DELIMITER ;

-- 调用存储过程 --
CALL fix_task_bug();

-- 删除存储过程 --
DROP PROCEDURE IF EXISTS fix_building_bug;
DROP TABLE IF EXISTS tempZ; 
