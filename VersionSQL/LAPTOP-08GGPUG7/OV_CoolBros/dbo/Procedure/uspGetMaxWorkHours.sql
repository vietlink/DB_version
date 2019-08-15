/****** Object:  Procedure [dbo].[uspGetMaxWorkHours]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetMaxWorkHours](@empId int, @headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @week1 decimal(18,8)
	DECLARE @week2 decimal(18,8)
	SELECT @week1 = SUM(WorkHours) FROM EmployeeWorkHours WHERE EmployeeID = @empId AND EmployeeWorkHoursHeaderID = @headerId AND [week] = 1
	SELECT @week2 = SUM(WorkHours) FROM EmployeeWorkHours WHERE EmployeeID = @empId AND EmployeeWorkHoursHeaderID = @headerId AND [week] = 1

	SELECT ISNULL(@week1, 0) as Week1, ISNULL(@week2, 0) as Week2
END

