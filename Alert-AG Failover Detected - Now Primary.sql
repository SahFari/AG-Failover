-- Found it at https://www.sqlservercentral.com/blogs/availability-group-issues-fixed-with-alerts

USE [msdb]
GO

IF NOT EXISTS (SELECT name FROM msdb.dbo.sysalerts WHERE name = N'AG Failover Detected - Now Primary')
EXEC msdb.dbo.sp_add_alert @name=N'AG Failover Detected - Now Primary', 
		@message_id=1480, 
		@severity=0, 
		@enabled=1, 
		@delay_between_responses=0, 
		@include_event_description_in=0, 
		@event_description_keyword=N'"RESOLVING" to "PRIMARY"', 
		@category_name=N'[Uncategorized]'
GO


