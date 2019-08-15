/****** Object:  Procedure [dbo].[uspHasLeaveBeenApproved]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspHasLeaveBeenApproved](@requestId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @approvedId int = 0;
	SELECT @approvedId = id FROM LeaveStatus WHERE Code = 'A';

	SELECT ISNULL(COUNT(*),0) as result FROM LeaveStatusHistory WHERE LeaveRequestID = @requestId AND LeaveStatusID = @approvedId
END

