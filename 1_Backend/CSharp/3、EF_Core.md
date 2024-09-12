# EF Core

>## ����

---

    1��������
        Microsoft.EntityFrameworkCore.SqlServer
        Microsoft.EntityFrameworkCore.Sqlite
        Pomelo.EntityFrameworkCore.MySql
        Microsoft.EntityFrameworkCore.InMemory �����ڴ����ݿ�
    2����ʹ�ð�����������.

[����](https://learn.microsoft.com/zh-cn/ef/core/get-started/overview/first-app?tabs=netcore-cli)

---

>## TPH��TPT��TPC

---

    1��TPH��Table Per Hierarchy
        ����EF��Ĭ�ϵļ̳�ӳ���ϵ��һ�ű��Ż��������������У��Զ����ɵ�discriminator���������ֻ������������ݡ�
        modelBuilder.Entity<Animal>().UseTphMappingStrategy();
    2��TPT��Table Per Type
        ����������ڲ�ͬ�ı��
        modelBuilder.Entity<Animal>().UseTptMappingStrategy();
        this.Map(m =>
            {
                m.ToTable("Lodgings");
            }).Map<CodeFirst.Model.Resort>(m =>
            {
                m.ToTable("Resorts");
            });
    3��TPC��Table Per Concrete Type
        Ϊÿ�����ཨ��һ����ÿ���������Ӧ�ı��а�����������Զ�Ӧ���к������������Զ�Ӧ���С�
        modelBuilder.Entity<Animal>().UseTpcMappingStrategy();
        this.Map(m =>
            {
                m.ToTable("Lodgings");
            }).Map<CodeFirst.Model.Resort>(m =>
            {
                m.ToTable("Resorts");
                m.MapInheritedProperties();
            });
    4���⼸�ַ�ʽ���ü̳�ӳ�䣬ʵ����Ŀ��Ӧ�����ĸ���:
        1�����Ƽ�ʹ��TPC(Type Per Concrete Type)����Ϊ��TPC��ʽ�������а������������ʵ����ʵ�����ϲ��ܱ�ӳ��Ϊ��֮��Ĺ�ϵ�������ͨ���ֶ��������������������������ԣ��Ӷ��� Code First��֪������֮��Ĺ�ϵ�������ַ�ʽ�Ǻ�ʹ��Code First�ĳ����෴�ģ�
        2���Ӳ�ѯ��������˵��TPH���һЩ����Ϊ���е����ݶ�����һ�����У�����Ҫ�����ݲ�ѯʱʹ��join��
        3���Ӵ洢�ռ�����˵��TPT���һЩ����Ϊʹ��TPHʱ���е��ж���һ�����У������еļ�¼������ʹ�����е��У������кܶ��е�ֵ��null���˷��˺ܶ�洢�ռ䣻
        4����������֤�ĽǶ���˵��TPT��һЩ����ΪTPH�кܶ��������Զ�Ӧ�����ǿ�Ϊ�յģ���Ϊ������֤�����˸����ԡ�
    5�����������

 [����](https://learn.microsoft.com/zh-cn/ef/core/modeling/inheritance)   

---

>## ��������(EF8֧��) ע�⣺��JSON���б��ʵ�����

---

    1���� EF Core �У�ʹ�� OwnsOne �� OwnsMany ����ۺ����͡�
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Author>().OwnsOne(
                author => author.Contact, ownedNavigationBuilder =>
                {
                    ownedNavigationBuilder.OwnsOne(contactDetails => contactDetails.Address);
                });
        }
    2�����ݿ���ֶΣ�����ʹ��������ʾ��һ��������ö������ϳ�һ��������User���ֶ���ΪAddress_City����ʾUser���Address��City�ֶΡ�
    3���������������
    
[����](https://learn.microsoft.com/zh-cn/ef/core/what-is-new/ef-core-8.0/whatsnew#value-objects-using-complex-types)

---

>## JSON��(EF7֧��) ע�⣺�͸��������б��ʵ�����

---

    1�����ToJsonʹ��JSON�С�
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Author>().OwnsOne(
                author => author.Contact, ownedNavigationBuilder =>
                {
                    ownedNavigationBuilder.ToJson();
                    ownedNavigationBuilder.OwnsOne(contactDetails => contactDetails.Address);
                });
        }
    2���������ϵ���ݿ�֧�ְ��� JSON �ĵ����С� ����ʹ�ò�ѯ��ȡ��Щ���е� JSON�� ���磬�������ĵ�Ԫ�ؽ���ɸѡ�������Լ���Ԫ�ش��ĵ���ͶӰ������С� JSON �������ϵ���ݿ�����ĵ����ݿ��һЩ�������Ӷ�������֮�䴴�����õĻ�ϡ�
    3������ʹ��JSON�н��в�ѯ���޸ġ�ɾ����

---

>## ��Ԫ���ͼ���(EF8֧��) ע�⣺����JSON��ʵ�֡�

---

    EF Core ���Խ��κ� IEnumerable<T> ���ԣ����� T �ǻ�Ԫ���ͣ�ӳ�䵽���ݿ��е� JSON �С�
    ����ʹ�ü��ϲ�ѯ��ת��ΪSQL Server��SQL���ʱ����ʹ��OpenJson��

---

>## �����Զ��ϵ  

---

    EF7 ֧�ֶ�Զ��ϵ������һ������һ��û�е������ԡ� ���·���Post��Tag����ᵼ�½���3����Tags,Posts,PostTag��
    ͬʱ��ע�⣬Post ���;��б���б�ĵ������ԣ��� Tag ����û�����µĵ������ԡ� �� EF7 �У�����Ȼ��������Ϊ��Զ��ϵ������ͬһ Tag ����������಻ͬ�����¡�
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
        
        // һ�仰��Ӷ������ݡ�
        var tags = new Tag[] { new() { TagName = "Tag1" }, new() { TagName = "Tag2" }, new() { TagName = "Tag2" }, };
        await context.AddRangeAsync(new Blog { Posts =
        {
            new Post { Tags = { tags[0], tags[1] } },
            new Post { Tags = { tags[1], tags[0], tags[2] } },
            new Post()
        } });
        await context.SaveChangesAsync();
            
---

>## ʵ����

---

    ʵ���ֽ�����ʵ������ӳ�䵽�����

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

>## δӳ�����͵�ԭʼSQL��ѯ(EF7֧��)

---

    1��ֱ��ʹ��SQL��ѯ���ݣ��������£�
    var postsIn2022 = await context.Database
        .SqlQuery<BlogPost>($"SELECT * FROM Posts as p WHERE p.PublishedOn >= {start} AND p.PublishedOn < {end}")
        .ToListAsync();
    2��ʹ�ô˷������ں���ֱ�Ӹ���Linq��䣬��ת����Ӧ��SQL��丽����ԭ����SQL�����档
    var summariesIn2022 = await context.Database.SqlQuery<PostSummary>(
            @$"SELECT b.Name AS BlogName, p.Title AS PostTitle, p.PublishedOn
               FROM Posts AS p
               INNER JOIN Blogs AS b ON p.BlogId = b.Id")
        .Where(p => p.PublishedOn >= cutoffDate && p.PublishedOn < end)
        .ToListAsync();

---

>## ���¡�ɾ��

---

    1������
    await context.Customers
    .Where(e => e.Name == name)
    .ExecuteUpdateAsync(
        s => s.SetProperty(b => b.CustomerInfo.Tag, "Tagged")
            .SetProperty(b => b.Name, b => b.Name + "_Tagged"));
    2��ɾ��
    await context.Tags.Where(t => t.Text.Contains(".NET")).ExecuteDeleteAsync();

---

>## ����ʵ���������ʵ���ϵĸ�������

---

    ���Դ����ַ����������LINQ��EF.Property<object>(e, sortProperty)��ʾ����e.[sortProperty]��
    Task<List<Customer>> GetPageOfCustomers(string sortProperty, int page)
    {
        using var context = new CustomerContext();

        return context.Customers
            .OrderBy(e => EF.Property<object>(e, sortProperty))
            .Skip(page * 20).Take(20).ToListAsync();
    }

---

>## �����ַ������ӳٳ�ʼ��

---

    �����ַ���ͨ���Ǵ������ļ���ȡ�ľ�̬�ʲ��� ���� DbContext ʱ���������ɽ���Щ��ݸ� UseSqlServer ������� ���ǣ���ʱ�����ַ������ܻ���ÿ��������ʵ�������ġ� ���磬���⻧ϵͳ�е�ÿ���⻧�����в�ͬ�������ַ�����
    ���������

[����](https://learn.microsoft.com/zh-cn/ef/core/what-is-new/ef-core-7.0/whatsnew#lazy-initialization-of-a-connection-string)

---

>## ��ѯ������ǿ

---

    1�����֧�ֵ�SQLת��
        Contains�� String.Join��String.Concat��string.IndexOf��typeof��Regex.IsMatch

---




