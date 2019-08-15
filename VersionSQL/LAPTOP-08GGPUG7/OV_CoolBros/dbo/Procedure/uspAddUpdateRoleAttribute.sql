/****** Object:  Procedure [dbo].[uspAddUpdateRoleAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateRoleAttribute](@roleid int, @attid int, @granted varchar(1))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT id FROM RoleAttribute WHERE roleid = @roleid AND attributeid = @attid) BEGIN
		UPDATE
			RoleAttribute
		SET
			granted = @granted
		WHERE
			roleid = @roleid AND attributeid = @attid
	END
	ELSE
		INSERT INTO RoleAttribute(roleid, attributeid, granted)
			VALUES(@roleid, @attid, @granted)
	END


