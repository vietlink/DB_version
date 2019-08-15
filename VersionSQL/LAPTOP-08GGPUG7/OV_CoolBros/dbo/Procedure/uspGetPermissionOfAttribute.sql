/****** Object:  Procedure [dbo].[uspGetPermissionOfAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetPermissionOfAttribute](@RoleIds varchar(200),@tablename varchar(100),@columnName varchar(100))
AS
BEGIN

declare @EntityId int 
declare @AttributeId int 

DECLARE @SEP varchar(1)
SET @SEP =','
DECLARE @SP INT
DECLARE @VALUE varchar(100)
CREATE TABLE #Temp2(Id int IDENTITY(1,1) not null,RoleId varchar(100) not null)


SET @EntityId =(select id from Entity where tablename =@tablename)
SET @AttributeId=(select ID from Attribute where columnname =@Columnname and entityid =@EntityId)
if(CHARINDEX (',',@RoleIds)> 0)
BEGIN

WHILE PATINDEX('%'+@SEP+'%',@RoleIds) <> 0
BEGIN
   SELECT  @SP = PATINDEX('%' + @SEP + '%',@RoleIds)
   SELECT  @VALUE = LEFT(@RoleIds , @SP - 1)
   SELECT  @RoleIds = STUFF(@RoleIds, 1, @SP, '')
   INSERT INTO #Temp2 (RoleId) VALUES (@VALUE)
END

if(@RoleIds <>'')
INSERT INTO #Temp2 (RoleId) VALUES (@RoleIds)




END
ELSE
BEGIN
	INSERT INTO #Temp2 (RoleId) VALUES (@RoleIds)
END


select roleid ,granted  from RoleAttribute where roleid in(select roleid  from #Temp2 ) and attributeid =@AttributeId


END




