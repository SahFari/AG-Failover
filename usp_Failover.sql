USE [master]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Failover]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[usp_Failover] AS' 
END
GO

ALTER   PROC [dbo].[usp_Failover] AS
	 
SET NOCOUNT ON
DECLARE @AGName sysname, 
@Command  nvarchar(Max);
	 
DECLARE AG_Cursor CURSOR STATIC FOR
				 
SELECT
Groups.[Name] AS AGname
	 
FROM sys.dm_hadr_availability_group_states States
	INNER JOIN master.sys.availability_groups Groups ON States.group_id = Groups.group_id
	 
WHERE primary_replica <> @@Servername
				              
OPEN AG_Cursor
FETCH NEXT FROM AG_Cursor into @AGName
WHILE @@FETCH_STATUS = 0
BEGIN
		 
	SELECT @Command = N'ALTER AVAILABILITY GROUP ' + @AGName + ' FAILOVER';
	EXEC sp_executesql @Command 
		  
FETCH NEXT FROM AG_Cursor into @AGName
END
CLOSE AG_Cursor
DEALLOCATE AG_Cursor
GO

ALTER AUTHORIZATION ON [dbo].[usp_Failover] TO  SCHEMA OWNER 
GO

ALTER AUTHORIZATION ON [dbo].[usp_Failover] TO  SCHEMA OWNER 
GO


