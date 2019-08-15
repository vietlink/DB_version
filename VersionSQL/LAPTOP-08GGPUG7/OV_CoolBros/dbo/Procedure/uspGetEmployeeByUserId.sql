/****** Object:  Procedure [dbo].[uspGetEmployeeByUserId]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeByUserId](@userid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM Employee e
	INNER JOIN [User] u
	ON e.accountname = u.accountname
	WHERE u.id = @userid
END


