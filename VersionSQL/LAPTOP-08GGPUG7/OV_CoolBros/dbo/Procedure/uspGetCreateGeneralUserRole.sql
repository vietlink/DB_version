/****** Object:  Procedure [dbo].[uspGetCreateGeneralUserRole]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCreateGeneralUserRole]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @roleid int = 0;
	SELECT top 1 @roleid = id FROM [Role] WHERE IsLoadRole = 1
    IF (@roleid < 1) BEGIN
		INSERT INTO [Role](code, name, description, type, enabled, usereditable, IsLoadRole)
			VALUES('General User', 'General User', 'General User', 'User', 'Y', 'Y', 1)
		SET @roleid = @@IDENTITY;
	END

	RETURN @roleid;

END


