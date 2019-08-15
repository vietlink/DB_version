/****** Object:  Procedure [dbo].[uspGetAllPolicyModules]    Committed by VersionSQL https://www.versionsql.com ******/


create procedure [dbo].[uspGetAllPolicyModules]
as
begin

select Id,Modulename from PolicyModules 

end
