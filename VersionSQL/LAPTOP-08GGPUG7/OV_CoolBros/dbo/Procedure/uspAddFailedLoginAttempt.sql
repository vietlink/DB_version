/****** Object:  Procedure [dbo].[uspAddFailedLoginAttempt]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddFailedLoginAttempt](@UserID varchar(50), @Date datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO LoginAttempts(UserID, LoggedDate)
		VALUES(@UserID, @Date);
	DECLARE @logCount int = 0;
	SELECT @logCount = COUNT(*) FROM LoginAttempts WHERE UserID = @UserID;
	IF @logCount >= 4 BEGIN
		IF NOT EXISTS (SELECT ID FROM LoginBannedList WHERE UserID = @UserID) BEGIN	
		INSERT INTO LoginBannedList(UserID, BannedDate)
			VALUES(@UserID, @Date)
		END
	END
END

