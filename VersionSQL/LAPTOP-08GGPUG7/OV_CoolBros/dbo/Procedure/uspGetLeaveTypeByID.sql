/****** Object:  Procedure [dbo].[uspGetLeaveTypeByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveTypeByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 l.*, p1.Title + ' - (' + p1.identifier + ')' as EscalatePosition1, p2.Title + ' - (' + p2.identifier + ')' as EscalatePosition2, p3.Title + ' - (' + p3.identifier + ')' as EscalatePosition3 FROM LeaveType l
	LEFT OUTER JOIN
	Position p1 
	ON p1.ID = l.Escalate1ID
	LEFT OUTER JOIN
	Position p2 
	ON p2.ID = l.Escalate2ID
	LEFT OUTER JOIN
	Position p3 
	ON p3.ID = l.Escalate3ID
	 WHERE l.id = @id;
END

