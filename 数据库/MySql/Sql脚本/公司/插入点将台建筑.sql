--  创建临时表保存副本产出数据 --
DROP TABLE IF EXISTS AfterCopyBuilding1; 
CREATE TEMPORARY TABLE AfterCopyBuilding1 
(
      LandID INT(10) NOT NULL , 
      BuildingID INT(10) NOT NULL , 
      BaseLv INT(10) NOT NULL 
);
INSERT INTO  AfterCopyBuilding (`LandID`, `BuildingID`, `BaseLv`) VALUES (11,1501,1);

--  插入数据 --
INSERT INTO `p_building` (`PlayerID`,`LandID`,`ID`,`BuildingID`,`BuildingLv`) SELECT f.id AS playerid,f.LandID,UUID(),f.BuildingID,f.BaseLv AS BuildingLv FROM 
(
SELECT e.* FROM (
--  查询出新规则下玩家应该有的建筑 --
SELECT a.`ID`,c.LandID,c.BuildingID,c.BaseLv,CONCAT(a.`ID`,'---', c.LandID) AS unitName FROM p_player a
INNER JOIN AfterCopyBuilding1 c ON 1=1
)e
-- 筛选以前就存在的建筑
WHERE unitName NOT IN(SELECT CONCAT(PlayerID,'---', LandID) FROM `p_building` )
)f