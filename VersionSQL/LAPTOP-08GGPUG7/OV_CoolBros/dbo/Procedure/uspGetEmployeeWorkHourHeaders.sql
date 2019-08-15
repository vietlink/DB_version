/****** Object:  Procedure [dbo].[uspGetEmployeeWorkHourHeaders]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeWorkHourHeaders](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId ORDER BY DateFrom DESC
END

