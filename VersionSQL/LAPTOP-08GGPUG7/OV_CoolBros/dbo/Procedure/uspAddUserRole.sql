/****** Object:  Procedure [dbo].[uspAddUserRole]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUserRole](@userid int, @roleid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF NOT EXISTS(SELECT * FROM RoleUser where userid = @userid AND roleid = @roleid) BEGIN
		INSERT INTO RoleUser(roleid, userid) VALUES(@roleid, @userid)
	END
END

