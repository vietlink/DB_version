/****** Object:  Procedure [dbo].[uspGetSupportedLeaveTypesByTypeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSupportedLeaveTypesByTypeID](@leaveTypeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--IF EXISTS (SELECT id FROM LeaveSupportedAccrueTypes WHERE LeaveTypeID = @leaveTypeID) BEGIN
		SELECT
			ISNULL(lsat.id, 0) as id,
			ISNULL(lsat.leavetypeid, @leaveTypeId) as LeaveTypeID,
			ISNULL(lsat.SupportedLeaveTypeID, lt.ID) as SupportedLeaveTypeID,
			ISNULL(lsat.AccrueLeave, 0) as AccrueLeave,
			lt.[Description] as LeaveType
		FROM
			LeaveType lt
		LEFT OUTER JOIN
			LeaveSupportedAccrueTypes lsat
		ON
			lt.ID = SupportedLeaveTypeID AND LeaveTypeID = @leaveTypeID
		WHERE
			lt.AccrueLeave = 1
	--END
	--ELSE BEGIN
	--	SELECT
	--		0 as ID,
	--		@leaveTypeID as LeaveTypeID,
	--		lt.ID as SupportedLeaveTypeID,
	--		0 as AccrueLeave,
	--		lt.[Description] as LeaveType
	--	FROM
	--		LeaveType lt
	--	WHERE
	--		lt.AccrueLeave = 1
	--END
	    
END

