/****** Object:  Procedure [dbo].[uspGetEmployees]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetEmployees](@Id int,@search varchar(100))     
/* ----------------------------------------------------------------------------------------------------------------    
 Name:  : $FunctionName    
 Description : Retrieve all records in the Employee table.    
 Author(s) : Clark Sayers    
 Date  : 01-October-2004    
 Notes  :    
-------------------------------------------------------------------------------------------------------------------    
 REVISIONS :    
 $Author  : $    
 $Date  : $    
 $History : $    
 $Revision  : $    
------------------------------------------------------------------------------------------------------------------- */    
     
     
AS    
    
 if(@Id =0)    
     
   SELECT     
    [id]    
    ,     
    [firstname]    
    ,     
    [secondname]    
    ,     
    [thirdname]    
    ,     
    [surname]    
    ,     
    [displayname]    
    ,    
    displayname+' - '+identifier  as 'displaynameidentifier'    
    ,     
    [firstnamepreferred]    
    ,     
    [title]    
    ,     
    [picture]    
    ,     
    [accountname]    
    ,     
    [status]    
    ,     
    [type]    
    ,     
    [dob]    
    --,     
    --[hired]    
    ,     
    [commencement]    
    --,     
    --[service]    
    ,     
    [termination]    
    --,     
   -- [retirement]    
    ,     
    [suspended]    
    ,     
    [gender]    
    ,     
    [maritalstatus]    
    --,     
   -- [dependents]    
    ,     
    [ethnicity]    
    ,     
    [nationality]    
    --,     
    --[healthnumber]    
    ,     
    AnnualLeaveTakenTotal as [annualleave]      
    ,     
    LSLTakenTotal as [longserviceleave]    
    ,     
    [location]    
    ,     
    [age]    
    ,     
    [companyserviceyears]    
    --,     
    --[groupserviceyears]    
    ,     
    [availabilitystatusid]    
    ,     
    [availabilitymessage]    
    ,    
    [identifier]    
   FROM [dbo].[Employee]    
   WHERE displayname like '%'+@search +'%' or accountname  like '%'+@search +'%' or firstname like '%'+@search +'%' or surname  like '%'+@search +'%' or secondname like '%'+@search +'%' or thirdname like '%'+@search +'%'    
   ORDER By displayname    
 else    
    SELECT     
    [id]    
    ,     
    [firstname]    
    ,     
    [secondname]    
    ,     
    [thirdname]    
    ,     
    [surname]    
    ,     
    [displayname]    
    ,     
    [firstnamepreferred]    
    ,     
    [title]    
    ,     
    [picture]    
    ,     
    [accountname]    
    ,     
    [status]    
    ,     
    [type]    
    ,     
    [dob]    
    --,     
   -- [hired]    
    ,     
    [commencement]    
   -- ,     
   -- [service]    
    ,     
    [termination]    
   -- ,     
    --[retirement]    
    ,     
    [suspended]    
    ,     
    [gender]    
    ,     
    [maritalstatus]    
    --,     
    --[dependents]    
    ,     
    [ethnicity]    
    ,     
    [nationality]    
   -- ,     
   -- [healthnumber]    
    ,     
    AnnualLeaveTakenTotal as [annualleave]    
    ,     
    LSLTakenTotal as [longserviceleave]   
    ,     
    [location]    
    ,     
    [age]    
    ,     
    [companyserviceyears]    
   -- ,     
   -- [groupserviceyears]    
    ,     
    [availabilitystatusid]    
    ,     
    [availabilitymessage]    
    ,    
    [identifier]    
   FROM [dbo].[Employee]    
   WHERE Id=@Id    
       
 IF @@error != 0    
 BEGIN    
      
RAISERROR ('General Error', 18, 1)    
    
  RETURN 1      
 END    
     
 RETURN 0

