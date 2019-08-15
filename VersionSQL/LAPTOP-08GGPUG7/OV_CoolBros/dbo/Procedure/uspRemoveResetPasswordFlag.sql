/****** Object:  Procedure [dbo].[uspRemoveResetPasswordFlag]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRemoveResetPasswordFlag] @userid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE
		[User]
	SET
		[RequiresPasswordReset] = 0
	WHERE
		id = @userid
END


