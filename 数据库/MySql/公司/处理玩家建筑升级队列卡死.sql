-- 修复玩家建筑升级队列卡死的bug脚本 --

DROP PROCEDURE IF EXISTS fix_building_bug;
DELIMITER //

-- 创建存储过程 --
CREATE PROCEDURE fix_building_bug()
BEGIN -- 开始存储过程

-- 定义玩家Id --
DECLARE player_id CHAR(36) DEFAULT '79dfa5ed-2749-435c-a555-e1a4d9a4ae8b'; 

DECLARE my_queueEnum INT (10); -- 自定义变量1
DECLARE my_queueId INT(10); -- 自定义变量2
DECLARE my_landId INT(10); -- 自定义变量3

-- 游标循环结束控制变量 --
DECLARE done BOOL DEFAULT FALSE;

-- 筛选出玩家卡死的建筑队列信息 --
DECLARE My_Cursor CURSOR FOR 
(SELECT 
  A.`QueueEnum` AS queueEnum,
  A.`ID` AS queueId,
  A.`NowBuildingLandID` AS landId
FROM
  p_building_queue AS A 
  LEFT JOIN g_event AS B 
    ON B.`ID` = CONCAT_WS(
      '_',
      A.`PlayerID`,
      CONCAT_WS('_', A.`QueueEnum`, A.`ID`)
    ) 
WHERE A.`IsInLvUp` = TRUE 
  AND A.`PlayerID` = player_id
  AND ISNULL(B.`ID`)) ;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; -- 绑定控制变量到游标,游标循环结束自动转true  

OPEN My_Cursor; -- 打开游标 
  myLoop:LOOP -- 开始循环体,myLoop为自定义循环名,结束循环时用到 
    FETCH My_Cursor INTO my_queueEnum,my_queueId,my_landId; -- 将游标当前读取行的数据顺序赋予自定义变量123
    IF done THEN
      LEAVE myLoop;
      END IF;
      
	-- 提升玩家建筑等级 --
	UPDATE `p_building` SET Buildinglv = Buildinglv + 1 WHERE PlayerID = player_id AND landid = my_landId;

	-- 修复建筑队列卡死 --
	UPDATE `p_building_queue` SET NowBuildingLandID = 0,IsInLvUp = 0 WHERE PlayerID = player_id AND QueueEnum = my_queueEnum AND id = my_queueId;
  
  END LOOP myLoop; -- 结束循环

  CLOSE My_Cursor; -- 关闭游标

END; -- 结束存储过程

//
DELIMITER ;

-- 调用存储过程 --
CALL fix_building_bug();

-- 删除存储过程 --
DROP PROCEDURE IF EXISTS fix_building_bug;
