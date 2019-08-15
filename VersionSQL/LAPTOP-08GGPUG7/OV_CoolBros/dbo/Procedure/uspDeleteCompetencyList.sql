/****** Object:  Procedure [dbo].[uspDeleteCompetencyList]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspDeleteCompetencyList](@EmpId int,@TypeId int)  
as   
begin  
delete from EmployeeCompetencyList where employeeid=@Empid and   
CompetencyListId in (select id from dbo.CompetencyList where CompetencyGroupId in (select id from CompetencyGroups where typeid=@TypeId)  
)  
end
