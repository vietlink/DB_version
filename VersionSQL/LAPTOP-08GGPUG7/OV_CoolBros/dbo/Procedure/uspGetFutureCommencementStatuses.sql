/****** Object:  Procedure [dbo].[uspGetFutureCommencementStatuses]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFutureCommencementStatuses](@nowDate datetime)
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
	(
		SELECT 
			esh.ID, EmployeeID, MIN(esh.StartDate) as StartDate
		FROM
			Employee e
		INNER JOIN
			EmployeeStatusHistory esh
		ON
			e.id = esh.EmployeeID
		WHERE
			e.commencement >= @nowDate
		GROUP BY
			esh.EmployeeID, esh.ID
	) as rs
	ON
		rs.id = esh.id
	INNER JOIN
		[Status] s
	ON
		s.id = esh.StatusID
	
END


