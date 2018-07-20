--  创建临时表保存数据 --
DROP TABLE IF EXISTS EquipAttrTemp; 
CREATE TABLE EquipAttrTemp 
(
      AttrSerial VARCHAR(32) NOT NULL , 
      AfteAttrSerial VARCHAR(32) NOT NULL , 
      Attr VARCHAR(32) NOT NULL , 
      AfterAttr VARCHAR(32) NOT NULL
);
INSERT INTO  EquipAttrTemp (`AttrSerial`,`AfteAttrSerial`,`Attr`,`AfterAttr`) VALUES ('"Lv":1,"Index":4','"Lv":1,"Index":6','204,25','206,25'),('"Lv":1,"Index":5','"Lv":1,"Index":7','205,25','207,25'),('"Lv":2,"Index":4','"Lv":2,"Index":6','204,37','206,37'),('"Lv":2,"Index":5','"Lv":2,"Index":7','205,37','207,37'),('"Lv":3,"Index":4','"Lv":3,"Index":6','204,56','206,56'),('"Lv":3,"Index":5','"Lv":3,"Index":7','205,56','207,56'),('"Lv":4,"Index":4','"Lv":4,"Index":6','204,83','206,83'),('"Lv":4,"Index":5','"Lv":4,"Index":7','205,83','207,83'),('"Lv":5,"Index":4','"Lv":5,"Index":6','204,125','206,125'),('"Lv":5,"Index":5','"Lv":5,"Index":7','205,125','207,125'),('"Lv":6,"Index":4','"Lv":6,"Index":6','204,188','206,188'),('"Lv":6,"Index":5','"Lv":6,"Index":7','205,188','207,188');

-- 任务处理 --
DROP PROCEDURE IF EXISTS fix_equip_attr_bug;
DELIMITER //

-- 创建存储过程 --
CREATE PROCEDURE fix_equip_attr_bug()
BEGIN -- 开始存储过程

DECLARE my_AttrSerial VARCHAR(32); -- 自定义变量2
DECLARE my_AfteAttrSerial VARCHAR(32); -- 自定义变量2
DECLARE my_Attr VARCHAR(32); -- 自定义变量1
DECLARE my_AfterAttr VARCHAR(32); -- 自定义变量2


-- 游标循环结束控制变量 --
DECLARE done BOOL DEFAULT FALSE;

-- 筛选出玩家卡死的建筑队列信息 --
DECLARE My_Cursor CURSOR FOR (SELECT * FROM EquipAttrTemp);

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; -- 绑定控制变量到游标,游标循环结束自动转true  

OPEN My_Cursor; -- 打开游标 
  myLoop:LOOP -- 开始循环体,myLoop为自定义循环名,结束循环时用到 
    FETCH My_Cursor INTO my_AttrSerial,my_AfteAttrSerial,my_Attr,my_AfterAttr; -- 将游标当前读取行的数据顺序赋予自定义变量123
    IF done THEN
      LEAVE myLoop;
      END IF;
      
	UPDATE `p_equip` SET ClearAttr=REPLACE(ClearAttr,my_Attr,my_AfterAttr),ClearValue=REPLACE(ClearValue,my_AttrSerial,my_AfteAttrSerial); 

  END LOOP myLoop; -- 结束循环

  CLOSE My_Cursor; -- 关闭游标

END; -- 结束存储过程

//
DELIMITER ;

-- 调用存储过程 --
CALL fix_equip_attr_bug();

-- 删除存储过程 --
DROP PROCEDURE IF EXISTS fix_equip_attr_bug;
DROP TABLE IF EXISTS EquipAttrTemp; 
