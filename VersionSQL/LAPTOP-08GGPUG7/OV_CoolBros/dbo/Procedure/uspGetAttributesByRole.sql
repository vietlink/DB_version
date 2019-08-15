/****** Object:  Procedure [dbo].[uspGetAttributesByRole]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAttributesByRole](@entityid int, @roleid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @excludeSourceId int = -1;
	SELECT @excludeSourceId = id FROM AttributeSource WHERE code = 'notused';

	IF @entityid = 0 BEGIN
		SELECT
			a.id, @roleid as roleid, a.ShortName as name, a.code, isnull(ra.granted, 'N') as granted, a.ispersonal, a.ismanagerial, a.IsPolicyBased, a.tab, a.PermissionAccess, ISNULL(a.FunctionHelp,'') as FunctionHelp
		FROM
			Attribute a
		INNER JOIN
			Entity e
		ON
			e.id = a.entityid
		LEFT OUTER JOIN
			RoleAttribute ra
		ON
			ra.attributeid = a.id AND ra.roleid = @roleid
		WHERE
			a.usereditable = 'Y' AND ISNULL(a.AttributeSourceID, 0) <> @excludeSourceId
		ORDER BY e.Ordering, a.sortorder, a.shortname
	END
	ELSE
		SELECT
			a.id, @roleid as roleid, a.ShortName as name, a.code, isnull(ra.granted, 'N') as granted, a.ispersonal, a.ismanagerial, a.IsPolicyBased, a.tab, a.PermissionAccess, ISNULL(a.FunctionHelp,'') as FunctionHelp
		FROM
			Attribute a
		LEFT OUTER JOIN
			RoleAttribute ra
		ON
			ra.attributeid = a.id AND ra.roleid = @roleid    
		WHERE a.entityid = @entityid AND a.usereditable = 'Y' AND ISNULL(a.AttributeSourceID, 0) <> @excludeSourceId
		ORDER BY a.sortorder, a.shortname
	END
