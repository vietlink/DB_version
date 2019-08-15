/****** Object:  Procedure [dbo].[uspGetLeaveApprovedDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveApprovedDate] 
	-- Add the parameters for the stored procedure here
	@id int, @approverID int, @statusCode int 
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select distinct lsh.LeaveRequestID,		
		lsh.ApproverEmployeeID,
		max(lsh.Date) over (partition by lsh.ApproverEmployeeID) as approved_date,
		lsh.LeaveStatusID
	from 
	LeaveStatusHistory lsh 
	where lsh.LeaveRequestID=@id and lsh.ApproverEmployeeID=@approverID
	--and lsh.LeaveStatusID=@statusCode
END

