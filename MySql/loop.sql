-- 修复玩家建筑升级队列卡死的bug脚本 --

DROP PROCEDURE IF EXISTS test;
DELIMITER //

-- 创建存储过程 --
CREATE PROCEDURE test()
BEGIN -- 开始存储过程


declare i int;

set i = 1;
while i < 1000000 do
insert into testB (id,number) values (i,1000000-i);
set i = i +1;wk
end while;


END; -- 结束存储过程

//
DELIMITER ;

-- 调用存储过程 --
CALL test();
