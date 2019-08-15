/****** Object:  Procedure [dbo].[uspGetAllRolesForADGroups]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAllRolesForADGroups](@ADGroupIds varchar(500)) 
AS
BEGIN
CREATE TABLE #Temp1(id int not null)
DECLARE @SEP varchar(1)
SET @SEP =','
DECLARE @SP INT
DECLARE @VALUE varchar(100)
if(CHARINDEX (',',@ADGroupIds)> 0)
BEGIN

WHILE PATINDEX('%'+@SEP+'%',@ADGroupIds) <> 0
BEGIN
   SELECT  @SP = PATINDEX('%' + @SEP + '%',@ADGroupIds)
   SELECT  @VALUE = LEFT(@ADGroupIds , @SP - 1)
   SELECT  @ADGroupIds = STUFF(@ADGroupIds, 1, @SP, '')
   INSERT INTO #Temp1 (id) VALUES (@VALUE)
END



select R.ID from [Role] R INNER JOIN RoleSecurityGroup  RS on RS.roleid =R.id WHERE RS.securitygroupid in (select id from #Temp1)
END
ELSE
BEGIN
select R.ID from [Role] R INNER JOIN RoleSecurityGroup  RS on RS.roleid =R.id WHERE RS.securitygroupid in (@ADGroupIds )

END

END

