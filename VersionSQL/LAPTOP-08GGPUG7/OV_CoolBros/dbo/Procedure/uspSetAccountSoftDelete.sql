/****** Object:  Procedure [dbo].[uspSetAccountSoftDelete]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetAccountSoftDelete](@accountName varchar(max), @softDeleted bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE [User] SET IsDeleted = @softDeleted WHERE accountname = @accountName
	IF @softDeleted = 1 BEGIN
		DECLARE @userId int = 0;
		SELECT @userId = id FROM [User] WHERE accountname = @accountName
		DELETE FROM RoleUser WHERE userid = @userId;
	END
END

