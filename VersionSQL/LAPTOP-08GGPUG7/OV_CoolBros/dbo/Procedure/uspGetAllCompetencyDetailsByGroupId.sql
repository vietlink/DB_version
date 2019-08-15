/****** Object:  Procedure [dbo].[uspGetAllCompetencyDetailsByGroupId]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[uspGetAllCompetencyDetailsByGroupId](@groupId int)  
as   
begin  
  
select CL.CompetencyGroupId,CL.CompetencyId,CL.Id as CompetencyListId,C.code as CompetencyCode,CG.description as CompetencyGroup,C.Description as Competency,    
   CG.Id as CompetencyGroupId,C.Id as CompetencyId from CompetencyList CL       
   inner join CompetencyGroups CG on CG.Id=CL.CompetencyGroupId       
   inner join Competencies C on C.id=CL.CompetencyId  
         
   where CL.CompetencyGroupId =@groupId  
   and CL.Enabled='Y' Order by C.Sortorder,C.Description   
end
