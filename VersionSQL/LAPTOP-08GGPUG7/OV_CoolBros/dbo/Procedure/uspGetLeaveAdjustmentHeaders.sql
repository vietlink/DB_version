/****** Object:  Procedure [dbo].[uspGetLeaveAdjustmentHeaders]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveAdjustmentHeaders](@search varchar(255))
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
		'1 Person' as forPerson
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
	ORDER BY la.CreatedDate desc

END

