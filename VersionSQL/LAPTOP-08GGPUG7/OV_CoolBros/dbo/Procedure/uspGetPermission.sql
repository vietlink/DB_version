/****** Object:  Procedure [dbo].[uspGetPermission]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspGetPermission](@roleids varchar(100),@Code varchar(100))  
as  
begin
CREATE TABLE #Temp2(Id int IDENTITY(1,1) not null,RoleId varchar(100) not null)  

DECLARE @SEP varchar(1)  
SET @SEP =','  
DECLARE @SP INT  
DECLARE @VALUE varchar(100)  

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

  
select A.Id,Ispersonal,Ismanagerial,isnull(Ra.granted,'N') as RoleBased from attribute A left outer join Roleattribute RA on A.Id=RA.AttributeId and RA.RoleId in(select roleid from #Temp2) where A.id =(select id from attribute where code=@Code)  
  
end


