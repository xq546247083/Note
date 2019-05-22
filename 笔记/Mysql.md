# Mysql

>## 一、Mysql注意事项

---

	防止sql注入：
		1、参数过滤特殊字符
		2、使用dapper
		3、使用MySqlParameter参数方式

---

>## 二、Mysql高性能优化

---

>### 1、表优化：

	1、整个表的字段都定长，查询速度会比包含不定长的字段的表快。
		定长字段：int，char(4)
		不定长字段：text
		所以建表的时候，定长字段和不定长字段，推荐分离在2个表中。
	2、常用字段和不常用字段分离。
	3、按业务分离。
	4、用合理的冗余字段来提高查询速度。
	5、字段类型优先级：整形>date,time>enum,char>varchar>blob,text
	6、text/Blob无法使用内存临时表（排序等操作只能在磁盘上进行）。
	7、允许为null的字段，会增加查询时间。

>### 2、索引优化：
	1、hash索引
	2、btree索引
	3、btree索引特征：
		(1)、同时只能用一个索引
		(2)、建立联合索引,联合索引的顺序很重要，因为索引有【左前缀原则】。
		例如：index(a,b,c)对a，b，c列进行索引。
			1、where a=1    a列索引发挥了作用
			2、where a=1 and b=1       a，b列索引发挥了作用
			3、where b=1 and a=1        a，b列索引发挥了作用
			4、where a=1 and c=1      a列索引发挥了作用
			5、where b= 1        没有索引列发挥作用
			6、where a=1 and b like 'sads%'    a，b列索引发挥了作用
			7、where a=1 and b like '%sads'      a列索引发挥了作用
			8、where a=1 order by b       a，b列索引发挥了作用
			9、where a=1 group by b       a，b列索引发挥了作用
	4、explain 分析sql语句
	5、innodb使用的聚簇索引。对联合索引来说，使用的是聚簇索引还是非聚簇索引，同一个语句，表现出来的查询速度会有一定的差别。
		表现：乱序插入，但是查询的数据还是按照主键排序的数据。
	6、理想的索引：
		1、查询频繁
		2、区分度高（接近1最为理想，根据实际情况决定）
		3、长度小
		4、尽量能覆盖常用查询字段
	7、伪哈希技巧。给一个列进行hash，并存到一个列中，对其进行索引。
	8、取数据要排序，争取使用索引排序，取出来自然有顺序。
	9、表索引碎片以及维护。维护方式:
		1、OPTIMIZE TABLE   xxx
		2、ALTER TABLE xxx  ENGINE INNODB
	
>### 3、SQL语句优化：
	1、少查，按索引查。
	2、查询创建临时表的数量。SHOW STATUS LIKE '%Created_tmp_%'
	3、In基本不能用
	4、内层from查询到的表是没有索引的，所以where，order尽量在内层就操作好。
	5、union all
	6、limit的查询时间随着offset的增大而增大。

---