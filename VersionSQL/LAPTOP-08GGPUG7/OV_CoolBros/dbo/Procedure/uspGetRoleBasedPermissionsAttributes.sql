/****** Object:  Procedure [dbo].[uspGetRoleBasedPermissionsAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetRoleBasedPermissionsAttributes](@AttributeIds varchar(max),@RoleIds varchar(500),@ADGroupUser int,@Loginname varchar(100),@MangerialFlag int)
AS
BEGIN
CREATE TABLE #Temp1(Id int IDENTITY(1,1) not null,AttributeId varchar(100) not null)
CREATE TABLE #Temp2(Id int IDENTITY(1,1) not null,RoleId varchar(100) not null)

DECLARE @SEP varchar(1)
SET @SEP =','
DECLARE @SP INT
DECLARE @VALUE varchar(100)
if(CHARINDEX (',',@AttributeIds)> 0)
BEGIN

WHILE PATINDEX('%'+@SEP+'%',@AttributeIds) <> 0
BEGIN
   SELECT  @SP = PATINDEX('%' + @SEP + '%',@AttributeIds)
   SELECT  @VALUE = LEFT(@AttributeIds , @SP - 1)
   SELECT  @AttributeIds = STUFF(@AttributeIds, 1, @SP, '')
   INSERT INTO #Temp1 (AttributeId) VALUES (@VALUE)
END
if(@AttributeIds <>'')
INSERT INTO #Temp1 (AttributeId) VALUES (@AttributeIds)

END
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

declare @PersonalCheck int
SET @PersonalCheck =0
if(@ADGroupUser =1)
BEGIN
DECLARE @Present int
SET @Present =(select ID  from Employee where accountname =@Loginname)
if(@Present is not null )
BEGIN
	if(@Present > 0)
	BEGIN
		SET @PersonalCheck =1
	END
END
END
PRINT @PersonalCheck
	
if(@PersonalCheck =1)
BEGIN
	select Ra.attributeid,Ra.granted,A.columnname,A.shortname,E.code+'.'+A.columnname as newcolumnname  from RoleAttribute RA INNER JOIN Attribute  A on A.id=RA.attributeid INNER JOIN Entity E on E.id=A.entityid   where RA.attributeid in (select attributeid  from #Temp1) and Ra.roleid in (select roleid from #Temp2 )
	
	UNION 
	select A.id as attributeid,'Y' as granted,columnname,shortname,E.code+'.'+A.columnname as newcolumnname  from Attribute A INNER JOIN Entity E on E.id=A.entityid where A.id in (select attributeid  from #Temp1) and ispersonal ='Y'
END
else if(@MangerialFlag =1)
BEGIN
	select attributeid,granted,A.columnname,A.shortname,E.code+'.'+A.columnname as newcolumnname from RoleAttribute RA INNER JOIN Attribute A on A.id=RA.attributeid INNER JOIN Entity E on E.id=A.entityid where attributeid in (select attributeid  from #Temp1) and roleid in (select roleid from #Temp2 )
	UNION 
	select A.id as attributeid,'Y' as granted,A.columnname,A.shortname ,E.code+'.'+A.columnname as newcolumnname from Attribute A INNER JOIN Entity E on E.id=A.entityid where A.id in (select attributeid  from #Temp1) and ismanagerial  ='Y' 
END
else
select A.id,RA.roleid,RA.attributeid,RA.granted,A.columnname,A.shortname,E.code+'.'+A.columnname as newcolumnname  from RoleAttribute RA INNER JOIN Attribute A on A.id=RA.attributeid INNER JOIN Entity E on E.id=A.entityid where attributeid in (select attributeid  from #Temp1) and roleid in (select roleid from #Temp2 )
DROP TABLE #Temp1
DROP TABLE #Temp2 
END

