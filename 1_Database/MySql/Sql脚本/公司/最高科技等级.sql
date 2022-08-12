-- 最高科技等级 --
SET @id:='';
SELECT @id:=Id FROM p_player WHERE NAME='阮子初';
REPLACE INTO player_pyc.p_science_skill (SELECT @id,b.id,MAX(lv) maxLV,0 FROM `model_dev`.b_science_skill_lv_r b GROUP BY ID );