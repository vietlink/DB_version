/****** Object:  Procedure [dbo].[uspGetCompetencyGroups]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[uspGetCompetencyGroups](@type int)  
as  
begin  
select id,TypeId,code,description from CompetencyGroups where typeid=@type and enabled='Y' Order by SortOrder  
end
