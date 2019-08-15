/****** Object:  Procedure [dbo].[uspGetRolesByUserID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRolesByUserID](@userId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM [User] u
	INNER JOIN
	RoleUser ru
	ON ru.userid = u.id
	INNER JOIN
	[Role] r
	ON ru.roleid = r.id
	WHERE u.id = @userId AND r.enabled = 'Y'
	ORDER BY r.name
END


