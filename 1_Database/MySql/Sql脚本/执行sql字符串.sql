SET @equipStrSql = CONCAT('CREATE TABLE ','`p_equipTemp',UNIX_TIMESTAMP(NOW()),'`  SELECT * FROM p_equip;');
PREPARE equipSql FROM @equipStrSql;
EXECUTE equipSql;
