/****** Object:  Procedure [dbo].[uspGetAllType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[uspGetAllType] 
as
begin
select id,code,description,IsSubCategExists from competencyTypes where enabled='Y' order by sortorder;
end

