/****** Object:  Procedure [dbo].[uspGetBannedLoginByCodeToken]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetBannedLoginByCodeToken] (@code varchar(50), @token varchar(50))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT lbl.*, u.accountname FROM LoginBannedList lbl
	INNER JOIN [User] u ON u.id = lbl.UserID
	WHERE lbl.Token = @token AND lbl.ResetCode = @code
END


