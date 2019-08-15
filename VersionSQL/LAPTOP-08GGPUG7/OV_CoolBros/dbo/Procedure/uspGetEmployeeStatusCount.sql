/****** Object:  Procedure [dbo].[uspGetEmployeeStatusCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeStatusCount](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @deleteStatus int = 0;
	SELECT @deleteStatus = ID FROM [Status] WHERE code = 'd'

    SELECT COUNT(*) as count FROM EmployeeStatusHistory WHERE EmployeeID = @empId --AND StatusID <> @deleteStatus
END

