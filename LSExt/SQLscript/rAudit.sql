use lansweeperdb;

go


-- =============================================
-- Author:		<Author,Savin,Nikolay>
-- Create date: <Create Date,27/05/2017,>
/* Description:	<Таблица для универсального триггера>
	https://stackoverflow.com/questions/19737723/log-record-changes-in-sql-server-in-an-audit-table
*/
-- =============================================
IF NOT EXISTS
      (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[dbo].[rAudit]') 
               AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
       CREATE TABLE rAudit 
               (Type CHAR(1), 
               TableName NVARCHAR(128), 
               PK NVARCHAR(1000), 
               FieldName NVARCHAR(128), 
               OldValue NVARCHAR(1000), 
               NewValue NVARCHAR(1000), 
               UpdateDate datetime, 
               UserName NVARCHAR(128))
GO