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
        modelBuilder.Entity<Animal>().UseTphMappingStrategy();
    2、TPT：Table Per Type
        父类和子类在不同的表里。
        modelBuilder.Entity<Animal>().UseTptMappingStrategy();
        this.Map(m =>
            {
                m.ToTable("Lodgings");
            }).Map<CodeFirst.Model.Resort>(m =>
            {
                m.ToTable("Resorts");
            });
    3、TPC：Table Per Concrete Type
        为每个子类建立一个表，每个与子类对应的表中包含基类的属性对应的列和子类特有属性对应的列。
        modelBuilder.Entity<Animal>().UseTpcMappingStrategy();
        this.Map(m =>
            {
                m.ToTable("Lodgings");
            }).Map<CodeFirst.Model.Resort>(m =>
            {
                m.ToTable("Resorts");
                m.MapInheritedProperties();
            });
    4、这几种方式配置继承映射，实际项目中应该用哪个呢:
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

>## 单向多对多关系  

---

    EF7 支持多对多关系，其中一方或另一方没有导航属性。 如下方的Post和Tag。这会导致建立3个表：Tags,Posts,PostTag。
    同时请注意，Post 类型具有标记列表的导航属性，但 Tag 类型没有文章的导航属性。 在 EF7 中，这仍然可以配置为多对多关系，允许将同一 Tag 对象用于许多不同的文章。
        public class Post
        {
            public int Id { get; set; }
            public string? Title { get; set; }
            public Blog Blog { get; set; } = null!;
            public List<Tag> Tags { get; } = new();
        }

        public class Post
        {
            public int Id { get; set; }
            public string? Title { get; set; }
            public Blog Blog { get; set; } = null!;
            public List<Tag> Tags { get; } = new();
        }

        modelBuilder
            .Entity<Post>()
            .HasMany(post => post.Tags)
            .WithMany();
        
        // 一句话添加多条数据。
        var tags = new Tag[] { new() { TagName = "Tag1" }, new() { TagName = "Tag2" }, new() { TagName = "Tag2" }, };
        await context.AddRangeAsync(new Blog { Posts =
        {
            new Post { Tags = { tags[0], tags[1] } },
            new Post { Tags = { tags[1], tags[0], tags[2] } },
            new Post()
        } });
        await context.SaveChangesAsync();
            
---

>## 实体拆分

---

    实体拆分将单个实体类型映射到多个表。

    CREATE TABLE [Customers] (
        [Id] int NOT NULL IDENTITY,
        [Name] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_Customers] PRIMARY KEY ([Id])
    );
        
    CREATE TABLE [PhoneNumbers] (
        [CustomerId] int NOT NULL,
        [PhoneNumber] nvarchar(max) NULL,
        CONSTRAINT [PK_PhoneNumbers] PRIMARY KEY ([CustomerId]),
        CONSTRAINT [FK_PhoneNumbers_Customers_CustomerId] FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id]) ON DELETE CASCADE
    );

    public class Customer
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string? PhoneNumber { get; set; }
    }

    modelBuilder.Entity<Customer>(
        entityBuilder =>
        {
            entityBuilder
                .ToTable("Customers")
                .SplitToTable(
                    "PhoneNumbers",
                    tableBuilder =>
                    {
                        tableBuilder.Property(customer => customer.Id).HasColumnName("CustomerId");
                        tableBuilder.Property(customer => customer.PhoneNumber);
                    });
        });

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
    3、使用{user}的方式，可以防止SQL注入。
    var user = "johndoe";
    var blogs = context.Blogs
        .FromSql($"SELECT * FROM [Blogs] WHERE User = {user}")
        .ToList();
    4、动态构建SQL(非SQL注入安全)
        var columnName = "Url";
        var columnValue = new SqlParameter("columnValue", "http://SomeURL");
        var blogs = context.Blogs
            .FromSqlRaw($"SELECT * FROM [Blogs] WHERE {columnName} = @columnValue", columnValue)
            .ToList();

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

>## 引用实体或复杂类型实例上的给定属性

---

    可以传入字符串，来表达LINQ。EF.Property<object>(e, sortProperty)表示代码e.[sortProperty]。
    Task<List<Customer>> GetPageOfCustomers(string sortProperty, int page)
    {
        using var context = new CustomerContext();

        return context.Customers
            .OrderBy(e => EF.Property<object>(e, sortProperty))
            .Skip(page * 20).Take(20).ToListAsync();
    }

---

>## 连接字符串的延迟初始化

---

    连接字符串通常是从配置文件读取的静态资产。 配置 DbContext 时，可以轻松将这些项传递给 UseSqlServer 或类似项。 但是，有时连接字符串可能会因每个上下文实例而更改。 例如，多租户系统中的每个租户可能有不同的连接字符串。
    具体见链接

[链接](https://learn.microsoft.com/zh-cn/ef/core/what-is-new/ef-core-7.0/whatsnew#lazy-initialization-of-a-connection-string)

---

>## 查询功能增强

---

    1、添加支持的SQL转换
        Contains、 String.Join、String.Concat、string.IndexOf、typeof、Regex.IsMatch

---

>## 创建DB

---

[链接](https://learn.microsoft.com/zh-cn/ef/core/dbcontext-configuration/)

---


>## 使用DbContext Pool

---

    1、依赖注入：
        builder.Services.AddDbContextPool<WeatherForecastContext>(o => o.UseSqlServer(builder.Configuration.GetConnectionString("WeatherForecastContext")));

    2、没有依赖注入：
        var options = new DbContextOptionsBuilder<PooledBloggingContext>()
            .UseSqlServer(@"Server=(localdb)\mssqllocaldb;Database=Blogging;Trusted_Connection=True;ConnectRetryCount=0")
            .Options;

        var factory = new PooledDbContextFactory<PooledBloggingContext>(options);

        using (var context = factory.CreateDbContext())
        {
            var allPosts = context.Posts.ToList();
        }

---

>## 配置实体

---

    1、DBContext中配置
        internal class MyContext : DbContext
        {
            public DbSet<Blog> Blogs { get; set; }

            protected override void OnModelCreating(ModelBuilder modelBuilder)
            {
                modelBuilder.Entity<Blog>()
                    .Property(b => b.Url)
                    .IsRequired();
            }
        }
    2、为了减小 OnModelCreating 方法的大小，可以将实体类型的所有配置提取到实现 IEntityTypeConfiguration<TEntity> 的单独类中。
        public class BlogEntityTypeConfiguration : IEntityTypeConfiguration<Blog>
        {
            public void Configure(EntityTypeBuilder<Blog> builder)
            {
                builder
                    .Property(b => b.Url)
                    .IsRequired();
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            new BlogEntityTypeConfiguration().Configure(modelBuilder.Entity<Blog>());
        }

        可以在给定程序集中应用实现 IEntityTypeConfiguration 的类型中指定的所有配置：
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(BlogEntityTypeConfiguration).Assembly);
    3、对实体类型使用 EntityTypeConfigurationAttribute
        [EntityTypeConfiguration(typeof(BookConfiguration))]
        public class Book
        {
            public int Id { get; set; }
            public string Title { get; set; }
            public string Isbn { get; set; }
        }
---

>## 分页

---

    1、偏移分页
        使用数据库实现分页的一种常见方法是使用 Skip 和 Take（SQL 中的 OFFSET 和 LIMIT）。遗憾的是，虽然这种技术非常直观，但也存在严重的缺点，性能较差。
    2、键集分页
        基于偏移的分页的建议替代方法（有时称为 键集分页或基于查找的分页分页）是简单地使用 WHERE 子句跳过行，而不是偏移量。 这意味着要记住提取的最后一个条目中的相关值（而不是其偏移量），并请求在该行之后的下一行。 例如，假设提取的上一页中最后一个条目 ID 值为 55，则只需执行以下操作：
        var lastId = 55;
        var nextPage = context.Posts
            .OrderBy(b => b.PostId)
            .Where(b => b.PostId > lastId)
            .Take(10)
            .ToList();

---

>## 实体对象和实体对象的关系

---

    1、体现在表中的外键关联。
    2、可以实现添加一个对象，多表插入的数据。
    3、
        一对多关系：单个实体与任意数量的其他实体关联。
        一对一关系：单个实体与另一个实体关联。
        多对多关系：任意数量的实体与任意数量的其他实体关联。

---

>## 更新数据

---

    1、获取、设置实体以及实体的属性的状态
        db.Entry(book).State;
        db.Entry(book).Property(r=>r.ID).IsModified;
    2、DbSet 的 Local 属性提供对当前由上下文跟踪且未标记为已删除的集实体的简单访问。 访问 Local 属性永远不会将查询发送到数据库。 这意味着，它通常在执行查询后使用。 
        db.Entry(book).Local;
    3、Attach的使用，避免更新、删除时，需要先查询数据出来。EF 的处理方式如下：
        1、把对象附加到上下文中，并把状态改为Modified、Deleted状态。
        2、调用Savechange方法时生成一段Update的SQL语句且Where条件为对象的主键Id，因为EF更新和删除都是根据主键ID来处理的。
        public void Update(Product product)
        {
            using(Entities ctx = new Entities) 
            {
                ctx.Attach(product);
                // 删除使用这个:EntityState.Deleted
                ctx.ObjectStateManager.ChangeObjectState(entity,EntityState.Modified) 
                ctx.SaveChange();
            }
        }

---

>## EF 代码生成器

---

    可以从数据库自动生成Model、EntityTypeConfiguration。
    参考链接1、链接2

[链接1](https://learn.microsoft.com/zh-cn/ef/core/managing-schemas/scaffolding/?tabs=dotnet-core-cli)
[链接2](https://learn.microsoft.com/zh-cn/ef/core/managing-schemas/scaffolding/templates?tabs=dotnet-core-cli)

---

>## EF 日志记录

---

    记录EF的操作日志。
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)=> optionsBuilder.LogTo(Console.WriteLine);
    参考链接

[链接](https://learn.microsoft.com/zh-cn/ef/core/logging-events-diagnostics/simple-logging)

---