/****** Object:  Procedure [dbo].[uspUpdateBannedResetCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateBannedResetCode](@Code varchar(50), @Token varchar(50), @UserID int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE LoginBannedList SET ResetCode = @Code, Token = @Token WHERE UserID = @UserID

END


