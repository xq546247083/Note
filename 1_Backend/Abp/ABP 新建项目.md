# ABP 新建项目

    1、abp new AbpStudy -t module -u mvc
    2、按照【https://docs.abp.io/zh-Hans/abp/latest/Entity-Framework-Core-MySQL】迁移数据库到MySQL。
        1、删除Migrations文件夹,并重新生成解决方案.
        2、在解决方案资源管理器选择 .DbMigrator (或 .Web) 做为启动项目并且选择 .Web.Unified/.AuthServer 做为默认项目
        3、在包管理控制台中运行 Add-Migration "Initial"；用以生成Migrations文件夹。
    3、使用包管理控制台运行 Update-Database 命令生成数据库。