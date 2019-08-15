/****** Object:  Procedure [dbo].[uspGetEmployeeGroupsEmployees]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [dbo].[uspGetEmployeeGroupsEmployees]    
( @employeegroupid udtId, @search varchar(255)    
)    
/* ----------------------------------------------------------------------------------------------------------------    
 Name:  : $FunctionName    
 Description : Retrieves all Employee records for the EmployeeGroup defined.    
 Author(s) : Clark Sayers    
 Date  : 01-October-2004    
 Notes  :    
-------------------------------------------------------------------------------------------------------------------    
 REVISIONS :    
 $Author  : Date  : History  : Revision     
-------------------------------------------------------------------------------------------------------------------    
 Alrie Coetzee 2010/05/05  A00132    
------------------------------------------------------------------------------------------------------------------- */    
     
AS    
    
SELECT [e].id,     
 [e].firstname,     
 [e].secondname,     
 [e].thirdname,     
 [e].surname,     
 [e].displayname,     
 [e].displayname+' - '+[e].identifier  as 'displaynameidentifier',    
 [e].firstnamepreferred,     
 [e].title,     
 [e].picture,     
 [e].accountname,     
 [e].status,     
 [e].type,     
 [e].dob,     
 --[e].hired,     
 [e].commencement,     
 --[e].service,     
 [e].termination,     
 --[e].retirement,     
 [e].suspended,     
 [e].gender,     
 [e].maritalstatus,     
 --[e].dependents,     
 [e].ethnicity,     
 [e].nationality,     
 --[e].healthnumber,     
 [e].annualleavedue,     
 [e].lsldue,     
 [e].location,     
 [e].age,     
 [e].companyserviceyears,     
 --[e].groupserviceyears,     
 [e].availabilitystatusid,     
 [e].availabilitymessage,    
 [e].identifier,
 [ege].IsLeader
FROM [dbo].[EmployeeGroup] eg,    
 [dbo].[EmployeeGroupEmployee] ege,    
 [dbo].[Employee] e    
WHERE eg.[id] = @employeegroupid    
AND eg.[id] = ege.[employeegroupid]    
AND ege.[empidentifier] = e.[identifier]    
AND
e.IsDeleted = 0
and isplaceholder = 0
AND
(displayname like '%'+@search +'%' or accountname  like '%'+@search +'%' or firstname like '%'+@search +'%' or surname  like '%'+@search +'%' or secondname like '%'+@search +'%' or thirdname like '%'+@search +'%')
order by surname
IF @@error != 0    
BEGIN    
 RAISERROR ('General Error', 18, 1)    
 RETURN 1      
END    
     
RETURN 0

