/****** Object:  Procedure [dbo].[uspGetAdminMainMenu]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAdminMainMenu](@UserId int,@RoleIds varchar(500))        
AS        
BEGIN     
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
    
if(@RoleIds <>'')    
INSERT INTO #Temp2 (RoleId) VALUES (@RoleIds)    
    
    
    
    
END    
ELSE    
BEGIN    
 INSERT INTO #Temp2 (RoleId) VALUES (@RoleIds)    
END       
if(@UserId =0)  
BEGIN      
select  distinct PM.Modulename,PM.Id as ModuleId,PM.PageURL,PM.ordering from Policy P inner join PolicyModules PM on PM.id=P.moduleid         
inner join RolePolicy RP on RP.policyid =P.id         
        
where PM.Sectioname='Admin' and roleid in (select roleid from #Temp2 )   ORDER by PM.ordering 
END        
  
ELSE      
  BEGIN      
select  distinct PM.Modulename,PM.Id as ModuleId,PM.PageURL,PM.ordering from Policy P inner join PolicyModules PM on PM.id=P.moduleid         
inner join RolePolicy RP on RP.policyid =P.id         
        
where PM.Sectioname='Admin' and roleid in (select roleid from RoleUser RU where userid =@UserId)   ORDER by PM.ordering      
END      
END
