/****** Object:  Procedure [dbo].[uspGetWorkContactReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWorkContactReport](@groupBy varchar(50), @sortBy varchar(50), @statusList varchar(max), @showGroups bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @statusTable TABLE([status] varchar(max));
	INSERT INTO @statusTable SELECT splitdata FROM fnSplitString(@statusList, ',');

	SELECT
		e.displayname,
		case when p.isplaceholder = 0 then p.title else '' end as positiontitle,
		p.orgunit2 as Division,
		p.orgunit3 as Department,
		ec.workphone,
		ec.workmobile,
		epi.id,
		epi.positionid,
		epi.employeeid
	FROM
		EmployeePosition epi
	INNER JOIN
		Employee e
		ON e.id = epi.employeeid
	INNER JOIN
		EmployeeContact ec
	ON
		ec.employeeid = epi.employeeid
	INNER JOIN
		Position p
	ON
		p.id = epi.positionid
	WHERE
		epi.primaryposition = 'y' and epi.isdeleted = 0 and (e.Status IN (SELECT [status] FROM @statusTable)) 
		AND e.displayname <> 'vacant' AND (@showGroups = 1 OR (@showGroups = 0 AND e.isplaceholder = 0))
	ORDER BY
		CASE @groupBy WHEN 'displayname' THEN e.displayname END,
		CASE WHEN @groupBy = 'positiontitle' THEN p.title END,
		CASE WHEN @groupBy = 'division' THEN p.orgunit2 END,
		CASE WHEN @groupBy = 'department' THEN p.orgunit3 END,
		CASE WHEN @sortBy = 'displayname' THEN e.displayname END,
		CASE WHEN @sortBy = 'positiontitle' THEN p.title END,
		CASE WHEN @sortBy = 'division' THEN p.orgunit2 END,
		CASE WHEN @sortBy = 'workphone' THEN ec.workphone END,
		CASE WHEN @sortBy = 'workmobile' THEN ec.workmobile END,
		CASE WHEN @sortBy = 'department' THEN p.orgunit3 END,
		CASE WHEN @sortBy = 'surname' THEN e.surname END,
		CASE WHEN @sortBy = 'surname' THEN e.firstname END
END
