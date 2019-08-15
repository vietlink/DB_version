/****** Object:  Procedure [dbo].[uspGetRolePoliciesForADGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetRolePoliciesForADGroup](@ADGroupIds varchar(500))  
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



select distinct P.id as PolicyId,P.code,P.name,P.description from RolePolicy RP inner join Policy P on P.id =RP.policyid 
 where RP.roleid in (select roleid  from RoleSecurityGroup where securitygroupid in (select id from #Temp1))
END
ELSE 
BEGIN
select distinct P.id as PolicyId,P.code,P.name,P.description from RolePolicy RP inner join Policy P on P.id =RP.policyid 
 where RP.roleid in (select roleid  from RoleSecurityGroup where securitygroupid in (@ADGroupIds))
END
END

