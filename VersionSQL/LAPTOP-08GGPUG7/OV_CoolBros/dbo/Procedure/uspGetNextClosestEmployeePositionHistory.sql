/****** Object:  Procedure [dbo].[uspGetNextClosestEmployeePositionHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetNextClosestEmployeePositionHistory](@empId int, @editId int, @enddate datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 startdate FROM EmployeePositionHistory WHERE id <> @editId AND employeeid = @empId AND startdate > @enddate AND primaryposition = 'Y' ORDER BY startdate ASC
END


