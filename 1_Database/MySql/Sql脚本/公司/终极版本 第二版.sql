--  创建临时表保存副本产出数据 --
DROP TABLE IF EXISTS AfterCopyBuilding; 
CREATE TABLE AfterCopyBuilding 
(
      NodeModelID INT(10) NOT NULL , 
      LandID INT(10) NOT NULL , 
      BuildingID INT(10) NOT NULL , 
      BaseLv INT(10) NOT NULL 
);
INSERT INTO  AfterCopyBuilding (`NodeModelID`,`LandID`, `BuildingID`, `BaseLv`) VALUES (10306,17,1703,1),(10506,18,1703,1),(10706,19,1703,1),(10906,20,1703,1),(11106,21,1703,1),(11306,22,1703,1),(11506,27,1704,1),(11706,28,1704,1),(11906,29,1704,1),(12106,30,1704,1),(12306,31,170,1),(12506,32,1704,1),(12706,37,1702,1),(12906,38,1702,1),(13106,39,1702,1),(13306,40,1702,1),(13506,41,1702,1),(13606,42,1702,1),(13806,44,1703,1),(13906,45,1703,1),(14106,46,1703,1),(14206,47,1703,1),(14406,48,1703,1),(14506,50,1704,1),(14606,51,1704,1),(14806,52,1704,1),(14906,53,1704,1),(15006,54,1704,1),(15206,56,1702,1),(15306,57,1702,1),(15406,58,1702,1),(15506,59,1702,1),(15606,60,1702,1);

DROP TABLE IF EXISTS buildingTempX; 
CREATE TABLE buildingTempX  SELECT CONCAT(PlayerID,'---', LandID) AS unitName FROM `p_building`;
ALTER TABLE `buildingTempX` ADD PRIMARY KEY ( `unitName` );

--  插入数据 --
INSERT INTO `p_building` (`PlayerID`,`LandID`,`ID`,`BuildingID`,`BuildingLv`) 
SELECT e.id AS playerid,e.LandID,UUID(),e.BuildingID,e.BaseLv AS BuildingLv FROM 
(
SELECT a.`ID`,b.`ChapterModelID`,c.LandID,c.BuildingID,c.BaseLv,CONCAT(a.`ID`,'---', c.LandID) AS unitName FROM p_player a
INNER JOIN `p_copy_node` b ON a.`ID`=b.`PlayerID` AND b.`IsPass`=TRUE
INNER JOIN AfterCopyBuilding c ON b.`NodeModelID`=c.NodeModelID
)e
LEFT JOIN buildingTempX d ON  e.unitName=d.unitName
WHERE d.unitName IS NULL;

DROP TABLE AfterCopyBuilding;
DROP TABLE buildingTempX;