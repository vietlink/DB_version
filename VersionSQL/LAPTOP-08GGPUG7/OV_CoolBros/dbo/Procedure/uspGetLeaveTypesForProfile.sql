/****** Object:  Procedure [dbo].[uspGetLeaveTypesForProfile]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveTypesForProfile](@empId int, @hourHeaderID int, @requestId int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @empId = 0 BEGIN
		SELECT * FROM LeaveType WHERE [Enabled] = 1 ORDER BY ISNULL(LeaveClassify, 99), [Description]
	END
	ELSE BEGIN
		DECLARE @commencementDate DateTime;
		SELECT @commencementDate = commencement FROM Employee where ID = @empId;
		
		SELECT * FROM LeaveType WHERE [Enabled] = 1
		ORDER BY ISNULL(LeaveClassify, 99), [Description]
	END
END

