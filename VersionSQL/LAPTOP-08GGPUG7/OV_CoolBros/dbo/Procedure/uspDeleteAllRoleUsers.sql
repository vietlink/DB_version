/****** Object:  Procedure [dbo].[uspDeleteAllRoleUsers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteAllRoleUsers](@roleId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE 
		ru
	FROM 
		RoleUser ru
	INNER JOIN
		[User] u
	ON 
		u.id = ru.userid
	INNER JOIN
		[Role] r
	ON
		r.id = ru.roleid AND r.id = @roleId
	WHERE
		case when u.type = 'BuiltIn' and r.[type] = 'BuiltIn' then 0 else 1 end = 1
END

