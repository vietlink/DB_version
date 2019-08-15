/****** Object:  Procedure [dbo].[uspAddEmployeeCompetencyList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspAddEmployeeCompetencyList](@EmpId int,@competencyListid int)  
as   
begin  
insert into EmployeeCompetencyList(employeeid,CompetencyListId) values(@empid,@competencyListid)  
end
