/****** Object:  Function [dbo].[fnDoesLeaveTypeSupportLeaveTypeAccrual]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnDoesLeaveTypeSupportLeaveTypeAccrual](@leaveTypeId int, @supportedLeaveTypeId int)
RETURNS bit
AS
BEGIN
	DECLARE @result bit;
	SELECT 
		@result = AccrueLeave FROM LeaveSupportedAccrueTypes WHERE LeaveTypeID = @leaveTypeID 
		AND  SupportedLeaveTypeID = @supportedLeaveTypeId
	RETURN @result;
END

