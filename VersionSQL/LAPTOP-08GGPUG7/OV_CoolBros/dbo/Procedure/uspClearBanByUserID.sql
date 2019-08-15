/****** Object:  Procedure [dbo].[uspClearBanByUserID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspClearBanByUserID](@userid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM ResetPasswordList WHERE UserID = @userid;
	DELETE FROM LoginAttempts WHERE UserID = @userid;
	DELETE FROM LoginBannedList WHERE UserID = @userid;
END


