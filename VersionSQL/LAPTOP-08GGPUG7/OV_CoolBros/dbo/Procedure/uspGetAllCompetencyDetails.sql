/****** Object:  Procedure [dbo].[uspGetAllCompetencyDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspGetAllCompetencyDetails](@type int,@EmployeeId int)  
as  
begin  
 if(@Type >0)  
 begin  
		 select CL.CompetencyGroupId,CL.CompetencyId,CL.Id as CompetencyListId,C.code as CompetencyCode,CG.description as CompetencyGroup,C.Description as Competency,
		 CG.Id as CompetencyGroupId,C.Id as CompetencyId,
		 isnull(EC.CompetencyListId,0) as CompetencyListIdSelected, ecr.[ShortDescription] as Ranking, ecr.RankingIndex
		 from CompetencyList CL   
		 inner join CompetencyGroups CG on CG.Id=CL.CompetencyGroupId
		 inner join CompetencyTypes CT on CT.Id = CG.TypeId  
		 inner join Competencies C on C.id=CL.CompetencyId      
		 Left outer join EmployeeCompetencyList EC on EC.EmployeeId=@EmployeeId and EC.CompetencyListId=CL.id  
		 left outer join EmployeeCompetencyRankings ecr ON ecr.Id = EC.EmployeeCompetencyRankingId
		 where CL.CompetencyGroupId in  (select id from CompetencyGroups where Typeid=@type and Enabled ='Y')  
		 and CL.Enabled='Y' Order by CT.SortOrder,CG.Sortorder,C.Description    
 end  
 else  
 begin  
		 select CL.CompetencyGroupId,CL.CompetencyId,CL.Id as CompetencyListId,C.code as CompetencyCode,CG.description as CompetencyGroup,C.Description as Competency,
		 CG.Id as CompetencyGroupId,C.Id as CompetencyId,
		 isnull(EC.CompetencyListId,0) as CompetencyListIdSelected, ecr.[ShortDescription] as Ranking, ecr.RankingIndex
		 from CompetencyList CL   
		 inner join CompetencyGroups CG on CG.Id=CL.CompetencyGroupId   
		 inner join CompetencyTypes CT on CT.Id = CG.TypeId
		 inner join Competencies C on C.id=CL.CompetencyId      
		 inner join EmployeeCompetencyList EC on EC.EmployeeId=@EmployeeId and EC.CompetencyListId=CL.id  
		 left outer join EmployeeCompetencyRankings ecr ON ecr.Id = EC.EmployeeCompetencyRankingId
		 where CL.CompetencyGroupId in  (select id from CompetencyGroups where Enabled ='Y')  
		 and CL.Enabled='Y' Order by CT.SortOrder,CG.Sortorder,C.Description    
 end   
    
end

