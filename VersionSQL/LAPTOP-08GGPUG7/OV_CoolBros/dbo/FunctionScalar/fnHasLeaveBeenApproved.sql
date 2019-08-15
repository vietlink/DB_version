/****** Object:  Function [dbo].[fnHasLeaveBeenApproved]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
-- This function checks to see if a request has been approved at any point in its life cycle
CREATE FUNCTION [dbo].[fnHasLeaveBeenApproved](@requestId int)
RETURNS int
AS
BEGIN
    DECLARE @approvedId int = 0;
	SELECT @approvedId = id FROM LeaveStatus WHERE Code = 'A';
	DECLARE @ret int;
	SELECT @ret = ISNULL(COUNT(*),0) FROM LeaveStatusHistory WHERE LeaveRequestID = @requestId AND LeaveStatusID = @approvedId
	RETURN @ret;
END

