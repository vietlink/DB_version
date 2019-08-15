/****** Object:  Procedure [dbo].[uspGetAllAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAllAttributes](@RoleIds varchar(500),@Rolebased int,@MixedModebased int)    
AS    
BEGIN    
CREATE TABLE #Temp1(Id int IDENTITY(1,1) not null,AttributeId varchar(100) not null)    
create TABLE #Temp2(Id int IDENTITY(1,1) not null,RoleId varchar(100) not null)    
    
DECLARE @SEP varchar(1)    
SET @SEP =','    
DECLARE @SP INT    
DECLARE @VALUE varchar(100)    
    
DECLARE @accessPermId int;
SELECT @accessPermId = id FROM Entity WHERE name = 'Access Permissions';

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
    
if(@Rolebased =1)    
BEGIN    
 select Ra.attributeid,Ra.granted,A.columnname,A.shortname,E.code+'.'+A.columnname as newcolumnname,E.code+A.columnname as gridcolumnField,'Rolebased' as ModeType  from RoleAttribute RA INNER JOIN Attribute  A on A.id=RA.attributeid INNER JOIN Entity E on E.id=A.entityid   where e.id <> @accessPermId AND E.usereditable='Y' and Ra.roleid in (select roleid from #Temp2 ) and A.usereditable ='Y'
     
END    
else if(@MixedModebased =1)    
BEGIN    
 select attributeid,granted,A.columnname,A.shortname,E.code+'.'+A.columnname as newcolumnname,E.code+A.columnname as gridcolumnField,'Rolebased' as ModeType  from RoleAttribute RA INNER JOIN Attribute A on A.id=RA.attributeid INNER JOIN Entity E on E.id=A.entityid WHERE e.id <> @accessPermId AND E.usereditable='Y' and 
roleid in (select roleid from #Temp2 ) and A.usereditable ='Y'  
 UNION     
 select A.id as attributeid,'Y' as granted,A.columnname,A.shortname ,E.code+'.'+A.columnname as newcolumnname,E.code+A.columnname as gridcolumnField,'Mangerialbased' as ModeType from Attribute A INNER JOIN Entity E on E.id=A.entityid where ismanagerial  ='Y' and e.id <> @accessPermId AND E.usereditable='Y'  and A.usereditable ='Y'    
 UNION     
 select A.id as attributeid,'Y' as granted,A.columnname,A.shortname ,E.code+'.'+A.columnname as newcolumnname,E.code+A.columnname as gridcolumnField,'Personalbased' as ModeType from Attribute A INNER JOIN Entity E on E.id=A.entityid where ispersonal  ='Y' AND e.id <> @accessPermId  and A.usereditable ='Y'    
END    
    
    
DROP TABLE #Temp2     
END

