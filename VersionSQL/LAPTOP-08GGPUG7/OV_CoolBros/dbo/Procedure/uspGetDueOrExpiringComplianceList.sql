/****** Object:  Procedure [dbo].[uspGetDueOrExpiringComplianceList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDueOrExpiringComplianceList](@dueDays int, @checkNotificationDays int, @daysAfter int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		e.id as employeeid,
		e.displayname as name,
		isnull(e.surname, '') as surname,
		c.Id as competencyid,
		c.[Description] as competency,
		ecl.DateFrom,
		ecl.DateTo,
		case when p.isplaceholder = 0 then p.title else '' end as position,
		cg.[Description] as Folder,
		ISNULL(DATEDIFF(day, GETDATE(), ecl.DateTo), 0) as expireDays,
		ecl.IsPositionRequirement,
		ec.WorkEmail,
		CASE
		WHEN isnull(DATEDIFF(day, GETDATE(), ecl.DateTo), 0) <= -@daysAfter THEN 'after'
		WHEN ecl.DateTo IS NULL THEN 'after'
		WHEN DATEDIFF(day, GETDATE(), ecl.DateTo) BETWEEN  CASE WHEN @checkNotificationDays = 0 THEN 1 ELSE -@checkNotificationDays END AND 1 THEN 'expired'
		WHEN DATEDIFF(day, GETDATE(), ecl.DateTo) BETWEEN (@dueDays - @checkNotificationDays) AND @dueDays THEN 'due'
		END as compliantType,
		ISNULL(u.id, 0) as userId,
		ecl.Id as eclId
		FROM
			EmployeeCompetencyList ecl
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
		INNER JOIN
			EmployeeContact ec
		ON
			ec.Employeeid = e.id
		LEFT OUTER JOIN
			[User] U
		ON
			u.displayname = e.displayname		
		WHERE
			ecl.IsMandatory = 1 AND ep.primaryposition = 'y' and ep.isdeleted = 0 and e.identifier <> 'Vacant'  AND c.[Type] = 2 AND c.[Type] = 2 AND e.IsDeleted = 0 AND (DATEDIFF(day, GETDATE(), ecl.DateTo) <= @dueDays OR ecl.DateFrom IS NULL)
		ORDER BY e.ID, DATEDIFF(day, GETDATE(), ecl.DateTo), e.surname, c.[Description] ASC
END
