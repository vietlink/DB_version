/****** Object:  Procedure [dbo].[uspClearFailedLogins]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspClearFailedLogins](@UserID int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM LoginAttempts WHERE UserID = @UserID;
	DELETE FROM LoginBannedList WHERE UserID = @UserID;
END


