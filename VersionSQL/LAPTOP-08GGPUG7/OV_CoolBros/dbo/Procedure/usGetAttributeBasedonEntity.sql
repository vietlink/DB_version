/****** Object:  Procedure [dbo].[usGetAttributeBasedonEntity]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[usGetAttributeBasedonEntity](@EntityId int,@RoleIds varchar(100))      
AS      
BEGIN      
 DECLARE @excludeSourceId int = -1;
 SELECT @excludeSourceId = id FROM AttributeSource WHERE code = 'notused';
 DECLARE @SEP varchar(1)          
 SET @SEP =','       
 DECLARE @SP INT          
 DECLARE @VALUE varchar(100)          
 CREATE TABLE #Temp2(Id int IDENTITY(1,1) not null,RoleId varchar(100) not null)          
       
 if(CHARINDEX (',',@RoleIds)> 0)          
 BEGIN      
  WHILE PATINDEX('%'+@SEP+'%',@RoleIds) <> 0          
  BEGIN          
     SELECT  @SP = PATINDEX('%' + @SEP + '%',@RoleIds)          
     SELECT  @VALUE = LEFT(@RoleIds , @SP - 1)          
     SELECT  @RoleIds = STUFF(@RoleIds, 1, @SP, '')          
     INSERT INTO #Temp2 (RoleId) VALUES (@VALUE)          
  END          
 END          
 if(@RoleIds <>'')          
 INSERT INTO #Temp2 (RoleId) VALUES (@RoleIds)          
 IF (@EntityId > 0)    
 SELECT distinct a.code, A.id,a.columnname,a.shortname,a.datatype  from RoleAttribute RA INNER JOIN Attribute A on A.id =RA.attributeid INNER JOIN Entity E on E.id=A.entityid and E.usereditable ='Y' and A.usereditable ='Y' WHERE A.entityid =@EntityId AND Ra.roleid in (select roleid from
 #Temp2 )  AND ISNULL(a.AttributeSourceID, 0) <> @excludeSourceId
       
 ELSE     
 BEGIN    
 DECLARE @lcount int    
 SET @lcount =0    
 SET @lcount =(select COUNT(Id) from #Temp2 )    
 if(@lcount =1)    
 SELECT distinct a.code, A.id,a.columnname,a.shortname,a.datatype  from RoleAttribute RA INNER JOIN Attribute A on A.id =RA.attributeid INNER JOIN Entity E on E.id=A.entityid and E.usereditable ='Y' and A.usereditable ='Y' WHERE Ra.roleid =CONVERT (int,@RoleIds)    
    
 else    
 SELECT distinct a.code, A.id,a.columnname,a.shortname,a.datatype  from RoleAttribute RA INNER JOIN Attribute A on A.id =RA.attributeid INNER JOIN Entity E on E.id=A.entityid and E.usereditable ='Y' and A.usereditable ='Y' WHERE Ra.roleid in (select roleid from #Temp2 ) AND ISNULL(a.AttributeSourceID, 0) <> @excludeSourceId       
 END    
drop table #temp2    
           
END

