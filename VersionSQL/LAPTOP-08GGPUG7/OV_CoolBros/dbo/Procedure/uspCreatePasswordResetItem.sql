/****** Object:  Procedure [dbo].[uspCreatePasswordResetItem]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreatePasswordResetItem](@userId int, @code varchar(50), @token varchar(50))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DELETE FROM ResetPasswordList WHERE UserID = @userId;
	INSERT INTO ResetPasswordList(UserID, ResetDate, ResetCode, Token)
		VALUES(@userId, GETDATE(), @code, @token)
END


