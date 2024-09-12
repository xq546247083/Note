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
    2��TPT��Table Per Type
        ����������ڲ�ͬ�ı��
    3��TPC��Table Per Concrete Type
        Ϊÿ�����ཨ��һ����ÿ���������Ӧ�ı��а�����������Զ�Ӧ���к������������Զ�Ӧ���С�
    4�������⼸�ַ�ʽ���ü̳�ӳ�䣬ʵ����Ŀ��Ӧ�����ĸ���:
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




