/****** Object:  Procedure [dbo].[uspGetUserIDByEmployeeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[uspGetUserIDByEmployeeID](@empID int, @ReturnValue int output)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SET @ReturnValue=( SELECT u.id FROM [User] u
	INNER JOIN Employee e
	ON e.accountname = u.accountname
	WHERE e.id = @empID)
END

