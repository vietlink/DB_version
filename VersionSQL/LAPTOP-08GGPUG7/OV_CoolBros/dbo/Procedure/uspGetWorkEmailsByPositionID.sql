/****** Object:  Procedure [dbo].[uspGetWorkEmailsByPositionID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWorkEmailsByPositionID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		DISTINCT ec.WorkEmail
	FROM
		Employee e
	INNER JOIN
		EmployeeContact ec
	ON
		e.ID = ec.employeeid
	INNER JOIN
		EmployeePosition ep
	ON	
		ep.EmployeeID = e.ID
	WHERE
		ep.IsDeleted = 0 AND e.IsDeleted = 0 AND ep.Positionid = @id AND ec.WorkEmail is not null AND ec.workEmail <> ''
END

