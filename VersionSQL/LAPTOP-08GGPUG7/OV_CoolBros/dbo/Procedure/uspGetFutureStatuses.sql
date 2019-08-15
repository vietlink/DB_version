/****** Object:  Procedure [dbo].[uspGetFutureStatuses]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFutureStatuses](@nowDate datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		esh.EmployeeID, esh.StartDate, s.[Description] as [Status]
	FROM
		EmployeeStatusHistory esh
	INNER JOIN
		[Status] s
	ON
		s.id = esh.StatusID
	WHERE
		DATEDIFF(day, esh.StartDate, @nowDate) = 1
END

