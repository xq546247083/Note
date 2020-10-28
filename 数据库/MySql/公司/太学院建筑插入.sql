--  创建临时表保存副本产出数据 --
DROP TABLE IF EXISTS AfterCopyBuilding3; 
CREATE TABLE AfterCopyBuilding3 
(
      LandID INT(10) NOT NULL , 
      BuildingID INT(10) NOT NULL , 
      BaseLv INT(10) NOT NULL 
);
INSERT INTO  AfterCopyBuilding3 (`LandID`, `BuildingID`, `BaseLv`) VALUES (11,1501,1);

-- 缓存唯一的已存在建筑
DROP TABLE IF EXISTS buildingTempY; 
CREATE TABLE buildingTempY  SELECT CONCAT(PlayerID,'---', LandID) AS unitName FROM `p_building`;
ALTER TABLE `buildingTempY` ADD PRIMARY KEY ( `unitName` );

--  插入数据 --
INSERT INTO `p_building` (`PlayerID`,`LandID`,`ID`,`BuildingID`,`BuildingLv`)
SELECT e.id AS playerid,e.LandID,UUID(),e.BuildingID,e.BaseLv AS BuildingLv FROM 
(
--  查询出新规则下玩家应该有的建筑 --
SELECT a.`ID`,c.LandID,c.BuildingID,c.BaseLv,CONCAT(a.`ID`,'---', c.LandID) AS unitName FROM p_player a
INNER JOIN AfterCopyBuilding3 c ON 1=1
)e
LEFT JOIN buildingTempY d ON  e.unitName=d.unitName
WHERE d.unitName IS NULL;


DROP TABLE AfterCopyBuilding3;
DROP TABLE buildingTempY;