INSERT INTO p_email
SELECT  UUID(),a.playerid,'00000000-0000-0000-0000-000000000000',22,'贵族礼包补偿','{"Des":"本次更新调整了贵族12礼包内的吕布将魂数量，鉴于你已购买对应的贵族礼包，文姬特在此给您补偿对应的将魂数量差额，请查收。","SenderName":"系统邮件"}','1408,14080049,20',FALSE,FALSE,NOW(),NOW(),DATE_ADD(NOW(), INTERVAL 30 DAY),NOW(),FALSE 
FROM `p_vip_gift` a WHERE id=33  AND TotalBuyNum = 1;

INSERT INTO p_email
SELECT  UUID(),a.playerid,'00000000-0000-0000-0000-000000000000',22,'贵族礼包补偿','{"Des":"本次更新调整了贵族13礼包内的吕布将魂数量，鉴于你已购买对应的贵族礼包，文姬特在此给您补偿对应的将魂数量差额，请查收。","SenderName":"系统邮件"}','1408,14080049,5',FALSE,FALSE,NOW(),NOW(),DATE_ADD(NOW(), INTERVAL 30 DAY),NOW(),FALSE 
FROM `p_vip_gift` a WHERE id=34  AND TotalBuyNum = 1;