# ElasticSearch

>## 1、倒排索引

---

	1、倒排索引也叫反向索引，我们通常理解的索引是通过key寻找value，与之相反，倒排索引是通过value寻找key，故而被称作反向索引。
	2、创建倒排索引是对正向索引的一种特殊处理，流程如下：
		1、将每一个文档的数据利用算法分词，得到一个个词条
		2、创建表，每行数据包括词条、词条所在文档id、位置等信息
		3、因为词条唯一性，可以给词条创建索引，例如hash表结构索引
	3、倒排索引举例：
		1、现在有2条数据如下：
			id 标题     价格
			1  小米手机  3999
			2  华为手机  3000
			3、 华为小米手环 2000
			4、小米手环 1000
		2、以上数据分词后，创建倒排索：
			词条 id列表
			小米 1、3、4
			手机 1、2
			华为 2、3
			手环 3、4
	4、倒排索引搜索流程举例：
		1、用户输入华为手机，通过分词得到：华为、手机
		2、通过倒排索引得到包含词条的数据有：2、3
		3、再在2、3中查询具体数据。

---

>## 2、映射属性

---

	1、type：字段数据类型，常见的简单类型有：
		1、字符串：text（可分词的文本）、keyword（精确值，例如：品牌、国家、ip地址）
			keyword类型只能整体搜索，不支持搜索部分内容
		2、数值：long、integer、short、byte、double、float、
		3、布尔：boolean
		4、日期：date
		5、对象：object
	2、index：是否创建索引，默认为true
	3、analyzer：使用哪种分词器
	4、properties：该字段的子字段

---

>## 3、查询分类

---

	1、查询所有：查询出所有数据，一般测试用。例如：match_all
	2、全文检索（full text）查询：利用分词器对用户输入内容分词，然后去倒排索引库中匹配。例如：
		match_query
		multi_match_query
	3、精确查询：根据精确词条值查找数据，一般是查找keyword、数值、日期、boolean等类型字段。例如：
		ids
		range
		term
	4、地理（geo）查询：根据经纬度查询。例如：
		geo_distance
		geo_bounding_box
	5、复合（compound）查询：复合查询可以将上述各种查询条件组合起来，合并查询条件。例如：
		bool
		function_score
	6、基本语法为：
		GET /indexName/_search
		{
			"query": {
				"查询类型": {
					"查询条件": "条件值"
				}
			}
		}
---

>## 4、查询案例

---

	1、match
		GET /indexName/_search
		{
			"query": {
				"match": {
					"all": "北京动物园"
				}
			}
		}

		GET /indexName/_search
		{
			"query": {
				"match": {
					"name": "北京动物园"
				}
			}
		}

	2、mulit_match【这个是经常使用的查询手段】
		GET /indexName/_search
		{
			"query": {
				"mulit_match": {
					"query": "北京动物园",
					"fields": ["name", " title"]
				}
			}
		}
	3、term
		GET /indexName/_search
		{
			"query": {
				"term": {
					"name": {
						"value":""动物园""
					}
				}
			}
		}

---

>## 5、复合查询

---

	1、复合（compound）查询：复合查询可以将其它简单查询组合起来，实现更复杂的搜索逻辑。常见的有两种：
		bool query：布尔查询，利用逻辑关系组合多个其它的查询，实现复杂搜索
		fuction score：算分函数查询，可以控制文档相关性算分，控制文档排名
	2、布尔查询是一个或多个查询子句的组合，每一个子句就是一个子查询。子查询的组合方式有：
		must：必须匹配每个子查询，类似“与”
		should：选择性匹配子查询，类似“或”
		must_not：必须不匹配，不参与算分，类似“非”
		filter：必须匹配，不参与算分
		【注意：尽量在筛选的时候多使用不参与算分的must_not和filter，以保证性能良好】
	3、算分函数查询是在搜索出来的结果的分数基础上，再手动与指定的数字进行一定运算来改变算分，从而改变结果的排序
		过滤条件：哪些文档要加分
		算分函数：如何计算function score
		加权方式：function score 与 query score如何运算
	4、function score的运行流程如下：
		1）根据原始条件查询搜索文档，并且计算相关性算分，称为原始算分（query score）
		2）根据过滤条件，过滤文档
		3）符合过滤条件的文档，基于算分函数运算，得到函数算分（function score）
		4）将原始算分（query score）和函数算分（function score）基于运算模式做运算，得到最终结果，作为相关性算分。
	5、复合查询案例：
		GET /hotel/_search
		{
			"query": {
			    "function_score": {           
				"query": { // 原始查询，可以是任意条件
					"bool": {
						"must": [
							{"term": {"city": "上海" }}
						],
						"should": [
							{"term": {"brand": "皇冠假日" }},
							{"term": {"brand": "华美达" }}
						],
						"must_not": [
							{ "range": { "price": { "lte": 500 } }}
						],
						"filter": [
							{ "range": {"score": { "gte": 45 } }}
						]
					}
				},
			      "functions": [ // 算分函数
			        {
			          "filter": { // 满足的条件，品牌必须是如家【品牌是如家的才加分，这里是加分条件】
			            "term": {
			              "brand": "如家"
			            }
			          },
			          "weight": 2 // 算分权重为2
			        }
			      ],
				"boost_mode": "sum" // 加权模式，求和
			    }
			  }  
		}
		

---

>## 6、查询结果

---

	1、包含以下设置
		query：查询条件
		from和size：分页条件
		sort：排序条件
		highlight：高亮条件
		aggs：定义聚合
	2、群集模式下,查询分页原理如下：
		1、elasticsearch内部分页时，必须先查询 0~1000条，然后截取其中的990 ~ 1000的这10条。
		2、在群集模式下，会在5个节点，查询其0-1000条，然后聚合，再重新排名，然后截取其中的990 ~ 1000的这10条。
		3、在这种模式下，如果查询的页数太大，会导致汇集的数据过多，导致内存和cpu的压力增大，不建议。
	
---