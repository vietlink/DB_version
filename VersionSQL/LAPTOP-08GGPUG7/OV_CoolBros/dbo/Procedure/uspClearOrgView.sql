/****** Object:  Procedure [dbo].[uspClearOrgView]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspClearOrgView](@Type int)  
AS  
BEGIN  
/*Execute the below SQL statement one by one for clearing the Database  
TYPE 1:Execute PART 1 for deleting the Data Only  
TYPE 2:Execute PART 1 and PART 2 for deleting the data and preference setup  
Execute PART 1, PART 2 and PART 3 for deleting the data, preference and Admin setup*/  
if(@Type =1) --Just deleting Data  
BEGIN  
  
  
/*****************PART 1*************************************************/  
truncate table EmployeePositionInfo2  
truncate table EmployeePositionInfo  
truncate table EmployeePosition   
truncate table EmployeeContact
truncate table EmployeeGroupEmployee
truncate table Eventlog 
truncate table ErrorTab 
  
truncate table EmployeeCompetencyList
truncate table EmployeeCompetencyRankings
truncate table CompetencyList
truncate table Competencies
truncate table CompetencyGroups
truncate table CompetencyTypes
truncate table Documents
truncate table DataFileUpload
truncate table [Status]

delete  from Employee   
dbcc checkident('Employee',reseed,0)  
  
delete  from position   
dbcc checkident('position',reseed,0)  
  
delete from EmployeeGroup  
dbcc checkident('EmployeeGroup',reseed,0)  

END  
  
/***************** PART 2 *************************************************/  
  
ELSE IF (@Type =2)--Delete Data and Preference Setting  
BEGIN  
truncate table EmployeePositionInfo2  
truncate table EmployeePositionInfo  
truncate table EmployeePosition   
truncate table EmployeeContact  
truncate table EmployeeGroupEmployee
truncate table Eventlog  
truncate table ErrorTab 
  
truncate table EmployeeCompetencyList
truncate table EmployeeCompetencyRankings
truncate table CompetencyList
truncate table Competencies
truncate table CompetencyGroups
truncate table CompetencyTypes
truncate table Documents
truncate table DataFileUpload

delete  from Employee   
dbcc checkident('Employee',reseed,0)  
  
delete  from position   
dbcc checkident('position',reseed,0)  
  
delete from EmployeeGroup  
dbcc checkident('EmployeeGroup',reseed,0)  
truncate table applicationPreference  
  
exec uspAddOrgViewBaseData @type  
  
END  
/*******PART 3*************************************************/  
ELSE IF (@Type =3)--Delete Data,Prefernce and Other Admin Settings  
BEGIN  
truncate table EmployeePositionInfo2  
truncate table EmployeePositionInfo  
truncate table EmployeePosition   
truncate table EmployeeContact   
truncate table EmployeeGroupEmployee  
truncate table Eventlog  
truncate table ErrorTab 

truncate table EmployeeCompetencyList
truncate table EmployeeCompetencyRankings
truncate table CompetencyList
truncate table Competencies
truncate table CompetencyGroups
truncate table CompetencyTypes
truncate table Documents
truncate table DataFileUpload

delete  from Employee   
dbcc checkident('Employee',reseed,0)  
  
delete  from position   
dbcc checkident('position',reseed,0)  
  
delete from EmployeeGroup  
dbcc checkident('EmployeeGroup',reseed,0)  
truncate table applicationPreference  
  
  
truncate table Rolesecuritygroup  
truncate table policymodules  
delete from RoleUser   
  
dbcc checkident('RoleUser',reseed,0)  
  
delete from RolePolicy   
dbcc checkident('RolePolicy',reseed,0)  
  
delete from RoleAttribute   
dbcc checkident('RoleAttribute',reseed,0)  
  
delete from policy  
dbcc checkident('policy','reseed',0)  
  
delete from securitygroup  
dbcc checkident('securitygroup','reseed',0)  
  
delete from [User]  
dbcc checkident('[User]','reseed',0)  
  
delete from Role  
dbcc checkident('role','reseed',0) 

update Setting set value='' where code in ('CE','AE') 
 
exec uspAddOrgViewBaseData 3  
  
END  
  
END

