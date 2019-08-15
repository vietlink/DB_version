/****** Object:  Procedure [dbo].[uspGetPermissionPoliciesByRole]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPermissionPoliciesByRole](@roleid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		*
	FROM
		RoleAttribute ra
	INNER JOIN
		Attribute a
	ON
		a.id = ra.attributeid
	WHERE
		a.[IsPolicyBased] = 1 AND ra.granted = 'Y'
END


