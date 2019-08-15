/****** Object:  Procedure [dbo].[uspGetAttributesByRoleID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAttributesByRoleID](@roleid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT r.attributeid FROM [RoleAttribute] r
	INNER JOIN attribute a on a.id = r.attributeid
	INNER JOIN entity e on e.id = a.entityid
	WHERE r.roleId = @roleid
	ORDER BY e.ordering, a.sortorder
END

