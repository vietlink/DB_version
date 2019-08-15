/****** Object:  Procedure [dbo].[uspGetEmployeeGroupsWithPermByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeGroupsWithPermByID](@empId int, @userid int, @search varchar(100), @lookupGroupId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM
		(SELECT 
			eg.id, eg.code, eg.name, eg.icon, eg.interfaceid,
			(select count(*) from EmployeeGroupEmployee ege inner join employee e on e.id = ege.employeeid where ege.employeegroupid = eg.id and e.isdeleted = 0) as count,
			eg.PermissionLevel,
			case eg.PermissionLevel
			when 0 then 1
			when 1 then 1
			when 2 then 
			case when (select top 1 id  from employeegroupemployee where employeeid = @empId and employeegroupid = eg.id) is not null or (select top 1 id from employeegroupadmin where userid = @userid and employeegroupid = eg.id) is not null then 1 else 0 end
			when 3 then
			case when (select top 1 id from employeegroupadmin where userid = @userid and employeegroupid = eg.id) is not null then 1 else 0 end
			end as yourpermission,
			case when (select top 1 id from employeegroupadmin where userid = @userid and employeegroupid = eg.id) is not null then 1 else 0 end as isadmin,
			dbo.fnCheckPermissionAttCode('empgroup-editall', 0, @userId, 0, 0, 0) as hasRole
		FROM
			EmployeeGroup eg
		WHERE (eg.code like '%'+@search +'%' or eg.name  like '%'+@search +'%')
	) as rs
	WHERE (rs.yourpermission = 1 or hasRole = 1) and rs.id = @lookupGroupId
END

