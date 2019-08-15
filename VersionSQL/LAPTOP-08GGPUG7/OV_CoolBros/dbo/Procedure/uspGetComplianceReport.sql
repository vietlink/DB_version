/****** Object:  Procedure [dbo].[uspGetComplianceReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Dale Gillin>
-- Create date: <05/05/2015>
-- Description:	<Compliance report>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetComplianceReport](@daysTillExpire int, @sortBy varchar(50), @groupBy varchar(50), @type varchar(2), @id int, @filterList varchar(max), @showExpired int, @showDue int, @showCurrent int, @statusList varchar(max), @filterPosOnly bit, @filterMandatory bit, @filterOptional bit)
AS
BEGIN

DECLARE @idTable TABLE(id varchar(max));
IF(LEN(@filterList) > 0) BEGIN	
	INSERT INTO @idTable SELECT * FROM fnSplitString(@filterList, ',');
END

DECLARE @statusTable TABLE([status] varchar(max));
INSERT INTO @statusTable SELECT splitdata FROM fnSplitString(@statusList, ',');

SELECT * FROM
(
	SELECT 
		e.id as employeeid,
		e.displayname as name,
		e.surname,
		c.Id as competencyid,
		c.[Description] as competency,
		ecl.DateFrom,
		ecl.DateTo,
		p.id as positionid,
		case when p.isplaceholder = 0 then p.title else '' end as position,
		cg.[Description] as Folder,
		ep.id as employeepositionid,
		CASE 
			WHEN
				Convert(DateTime, DATEDIFF(DAY, 0, GETDATE())) BETWEEN ecl.DateFrom AND ecl.DateTo
				THEN
					CASE WHEN DATEADD(day, @daysTillExpire, GETDATE()) > ecl.DateTo THEN 1 ELSE 2 END				
				ELSE 0
			END
		AS
			[Type],
		DATEDIFF(day, GETDATE(), ecl.DateTo) as expireDays,
		1 as rowType,
		ecl.ispositionrequirement,
		ech.scoretype,
		ech.scorerange,
		ech.scorealpha,
		ech.scoredecimal,
		ech.additionalinfo,
		ech.issuedate,
		ecl.Reference,
		ecl.IsMandatory
		FROM
			EmployeeCompetencyList ecl
		INNER JOIN
			EmployeeComplianceHistory ech
		ON
			ecl.id = ech.EmployeeCompetencyListID
		INNER JOIN
			CompetencyList cl
		ON
			cl.id = ecl.CompetencyListId
		INNER JOIN
			Competencies c
		ON
			c.id = cl.competencyid
		INNER JOIN
			CompetencyGroups cg
		ON
			cg.id = cl.competencygroupid
		INNER JOIN
			Employee e
		ON
			e.id = ecl.Employeeid
		INNER JOIN
			EmployeePosition ep
		ON
			ep.employeeid = e.id
		INNER JOIN
			EmployeePosition empPos
		ON
			ep.id = empPos.id AND empPos.primaryposition = 'Y'
		INNER JOIN
			Position p
		ON
			p.id = ep.positionid	
		WHERE
			(ecl.ismandatory = 1 OR ecl.hascompliance = 1) AND ep.primaryposition = 'y' and ep.isdeleted = 0 and e.identifier <> 'Vacant'  AND c.[Type] = 2 AND c.[Type] = 2 AND (e.Status IN (SELECT [status] FROM @statusTable))
	)
	AS rs
	WHERE
	(
		(@showDue = 1 AND rs.[Type] = 1) OR
		(@showExpired = 1 AND rs.[Type] = 0) OR
		(@showCurrent = 1 AND rs.[Type] = 2)
	)
	AND
	(
		(@type = '') OR
		(@type = 'p' AND rs.positionid = @id) OR
		(@type = 'e' AND rs.employeeid = @id)
	)
	AND
	(
		@filterPosOnly = 0 OR
		(@filterPosOnly = 1 AND rs.ispositionrequirement = 1)
	)
	AND
	(
		((LEN(@filterList) > 0 AND rs.competencyid IN (SELECT cast(id as int) FROM @idTable)) OR LEN(@filterList) = 0)
	)
	AND
	(
		(@filterMandatory = 1 AND rs.IsMandatory = 1) OR
		(@filterOptional = 1 AND rs.IsMandatory = 0)
	)
	ORDER BY rs.[Type], 
		CASE @groupBy WHEN 'surname' THEN rs.surname END,
		CASE WHEN @groupBy = 'name' THEN rs.name END,
		CASE WHEN @groupBy = 'position' THEN rs.position END,
		CASE WHEN @groupBy = 'competency' THEN rs.competency END,
		CASE WHEN @groupBy = 'datefrom' THEN rs.datefrom END,
		CASE WHEN @groupBy = 'dateto' THEN rs.dateto END,
		CASE WHEN @groupBy = 'folder' THEN rs.Folder END,
		CASE WHEN @groupBy = 'issuedate' THEN rs.IssueDate END,
		CASE WHEN @groupBy = 'ispositionrequirement' THEN rs.ispositionrequirement END,
		CASE WHEN @groupBy = 'ismandatory' THEN rs.IsMandatory END,
		CASE WHEN @sortBy = 'surname' THEN rs.surname END,
		CASE WHEN @sortBy = 'name' THEN rs.name END,
		CASE WHEN @sortBy = 'position' THEN rs.position END,
		CASE WHEN @sortBy = 'competency' THEN rs.competency END,
		CASE WHEN @sortBy = 'datefrom' THEN rs.datefrom END,
		CASE WHEN @sortBy = 'dateto' THEN rs.dateto END,
		CASE WHEN @sortBy = 'folder' THEN rs.Folder END,
		CASE WHEN @sortBy = 'daystillasc' THEN rs.expireDays END ASC,
		CASE WHEN @sortBy = 'daystilldesc' THEN rs.expireDays END DESC,
		CASE WHEN @sortBy = 'ispositionrequirement' THEN rs.ispositionrequirement END,
		CASE WHEN @sortBy = 'ismandatory' THEN rs.IsMandatory END,
		CASE WHEN @sortBy = 'Surname' THEN rs.surname END,
		CASE WHEN @sortBy = 'issuedate' THEN rs.IssueDate END
END
