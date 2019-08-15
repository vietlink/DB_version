/****** Object:  Procedure [dbo].[uspGetEmployeeLeaveTypes]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeLeaveTypes](@empId int, @headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		elt.ID as ID,
		@empId as EmployeeID,
		lt.ID as LeaveTypeID,
		ISNULL(elt.Enabled, 0) as [Enabled],
		@headerId as EmployeeWorkHoursHeaderID,
		lt.[Enabled] as TypeEnabled		
	FROM 
		LeaveType lt
		
	LEFT OUTER JOIN
		EmployeeLeaveTypes elt 
	ON
		lt.ID = elt.LeaveTypeID AND elt.EmployeeID = @empId AND elt.EmployeeWorkHoursHeaderID = @headerId
END
