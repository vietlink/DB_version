/****** Object:  Procedure [dbo].[uspGetLeaveAdjustmentHeaders1]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveAdjustmentHeaders1](@search varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		la.*,
		(-la.DebitAmount) + la.CreditAmount as hours,
		'' as [for],
		lt.Description as LeaveType,
		u.displayname as CreatedByName,
		(select count(id) from LeaveAdjustmentPeople where LeaveAdjustmentHeaderID = la.ID) as forCount,
		eSingle.displayname as forPerson
	FROM
		LeaveAdjustmentHeader la
	INNER JOIN
		LeaveType lt
	ON
		lt.ID = la.LeaveTypeID
	INNER JOIN
		[User] u
	ON
		u.ID = la.CreatedBy
	OUTER APPLY
	(SELECT TOP 1 ee.displayname as displayname FROM LeaveAdjustmentPeople lap INNER JOIN Employee ee ON ee.id = lap.EmployeeID WHERE lap.LeaveAdjustmentHeaderID = la.ID) eSingle
	where
	la.Date like '%'+@search+'%' OR lt.Description like '%'+ @search +'%' or u.displayname like '%'+@search+'%' or eSingle.displayname like '%'+@search+'%' or la.Reason like '%'+@search+'%'
	ORDER BY la.CreatedDate desc

END
