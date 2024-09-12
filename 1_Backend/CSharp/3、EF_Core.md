# EF Core

>## 概述

---

    1、包名：
        Microsoft.EntityFrameworkCore.SqlServer
        Microsoft.EntityFrameworkCore.Sqlite
        Pomelo.EntityFrameworkCore.MySql
        Microsoft.EntityFrameworkCore.InMemory 本地内存数据库
    2、简单使用案例，见链接.

[链接](https://learn.microsoft.com/zh-cn/ef/core/get-started/overview/first-app?tabs=netcore-cli)

---

>## TPH、TPT、TPC

---

    1、TPH：Table Per Hierarchy
        这是EF的默认的继承映射关系：一张表存放基类和子类的所有列，自动生成的discriminator列用来区分基类和子类的数据。
    2、TPT：Table Per Type
        父类和子类在不同的表里。
    3、TPC：Table Per Concrete Type
        为每个子类建立一个表，每个与子类对应的表中包含基类的属性对应的列和子类特有属性对应的列。
    4、讲了这几种方式配置继承映射，实际项目中应该用哪个呢:
        1、不推荐使用TPC(Type Per Concrete Type)，因为在TPC方式中子类中包含的其他类的实例或实例集合不能被映射为表之间的关系。你必须通过手动地在类中添加依赖类的主键属性，从而让 Code First感知到它们之间的关系，而这种方式是和使用Code First的初衷相反的；
        2、从查询性能上来说，TPH会好一些，因为所有的数据都存在一个表中，不需要在数据查询时使用join；
        3、从存储空间上来说，TPT会好一些，因为使用TPH时所有的列都在一个表中，而表中的记录不可能使用所有的列，于是有很多列的值是null，浪费了很多存储空间；
        4、从数据验证的角度来说，TPT好一些，因为TPH中很多子类属性对应的列是可为空的，就为数据验证增加了复杂性。
    5、具体见链接

 [链接](https://learn.microsoft.com/zh-cn/ef/core/modeling/inheritance)   

---

>## 复杂类型(EF8支持) 注意：和JSON列有本质的区别。

---

    1、在 EF Core 中，使用 OwnsOne 和 OwnsMany 定义聚合类型。
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Author>().OwnsOne(
                author => author.Contact, ownedNavigationBuilder =>
                {
                    ownedNavigationBuilder.OwnsOne(contactDetails => contactDetails.Address);
                });
        }
    2、数据库的字段，可以使用类来表示。一个表可以用多个类组合成一个类来表达。User表字段名为Address_City，表示User类的Address的City字段。
    3、具体见以下链接
    
[链接](https://learn.microsoft.com/zh-cn/ef/core/what-is-new/ef-core-8.0/whatsnew#value-objects-using-complex-types)

---

>## JSON列(EF7支持) 注意：和复杂类型有本质的区别。

---

    1、添加ToJson使用JSON列。
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Author>().OwnsOne(
                author => author.Contact, ownedNavigationBuilder =>
                {
                    ownedNavigationBuilder.ToJson();
                    ownedNavigationBuilder.OwnsOne(contactDetails => contactDetails.Address);
                });
        }
    2、大多数关系数据库支持包含 JSON 文档的列。 可以使用查询钻取这些列中的 JSON。 例如，这允许按文档元素进行筛选和排序，以及将元素从文档中投影到结果中。 JSON 列允许关系数据库采用文档数据库的一些特征，从而在两者之间创建有用的混合。
    3、可以使用JSON列进行查询、修改、删除。

---

>## 基元类型集合(EF8支持) 注意：基于JSON列实现。

---

    EF Core 可以将任何 IEnumerable<T> 属性（其中 T 是基元类型）映射到数据库中的 JSON 列。
    可以使用集合查询，转换为SQL Server的SQL语句时，会使用OpenJson。

---

>## 未映射类型的原始SQL查询(EF7支持)

---

    1、直接使用SQL查询数据，案例如下：
    var postsIn2022 = await context.Database
        .SqlQuery<BlogPost>($"SELECT * FROM Posts as p WHERE p.PublishedOn >= {start} AND p.PublishedOn < {end}")
        .ToListAsync();
    2、使用此方法，在后面直接跟上Linq语句，会转成相应的SQL语句附加在原本的SQL语句后面。
    var summariesIn2022 = await context.Database.SqlQuery<PostSummary>(
            @$"SELECT b.Name AS BlogName, p.Title AS PostTitle, p.PublishedOn
               FROM Posts AS p
               INNER JOIN Blogs AS b ON p.BlogId = b.Id")
        .Where(p => p.PublishedOn >= cutoffDate && p.PublishedOn < end)
        .ToListAsync();

---

>## 更新、删除

---

    1、更新
    await context.Customers
    .Where(e => e.Name == name)
    .ExecuteUpdateAsync(
        s => s.SetProperty(b => b.CustomerInfo.Tag, "Tagged")
            .SetProperty(b => b.Name, b => b.Name + "_Tagged"));
    2、删除
    await context.Tags.Where(t => t.Text.Contains(".NET")).ExecuteDeleteAsync();

---




