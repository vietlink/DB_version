/****** Object:  Procedure [dbo].[uspGetTerminationsByReason]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTerminationsByReason](@date datetime, @listDivision varchar(max), @listDepartment varchar(max), @listLocation varchar(max), @listEmployeeStatus varchar(max), @listEmployeeType varchar(max))
AS
BEGIN
	declare @divisionTable table (idDivisionTable varchar(max));
	declare @departmentTable table (idDepartmentTable varchar(max));
	declare @locationTable table (idLocationTable varchar(max));	
	declare @employeeStatusTable table (idEmployeeStatusTable varchar(max));
	declare @employeeTypeTable table (idEmployeeTypeTable varchar(max));	

	DECLARE @terminatedId int;
	SELECT @terminatedId = ID FROM [Status] WHERE Code = 'T'

	IF CHARINDEX(',', @listDivision, 0) > 0 BEGIN
		INSERT INTO @divisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@listDivision, ',');	
    END
    ELSE IF LEN(@listDivision) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @divisionTable(idDivisionTable) VALUES(@listDivision);	
    END

	IF CHARINDEX(',', @listDepartment, 0) > 0 BEGIN
		INSERT INTO @departmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@listDepartment, ',');	
    END
    ELSE IF LEN(@listDepartment) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @departmentTable(idDepartmentTable) VALUES(@listDepartment);	
    END

	IF CHARINDEX(';', @listLocation, 0) > 0 BEGIN
		INSERT INTO @locationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@listLocation, ';');	
    END
    ELSE IF LEN(@listLocation) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @locationTable(idLocationTable) VALUES(@listLocation);	
    END
	
	IF CHARINDEX(',', @listEmployeeType, 0) > 0 BEGIN
		INSERT INTO @employeeTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@listEmployeeType, ',');	
    END
    ELSE IF LEN(@listEmployeeType) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeTypeTable(idEmployeeTypeTable) VALUES(@listEmployeeType);	
    END	

	IF CHARINDEX(',', @listEmployeeStatus, 0) > 0 BEGIN
		INSERT INTO @employeeStatusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@listEmployeeStatus, ',');	
    END
    ELSE IF LEN(@listEmployeeStatus) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeStatusTable(idEmployeeStatusTable) VALUES(@listEmployeeStatus);	
    END		
	SET NOCOUNT ON;

	SELECT
		'Total' as Item,
		(
			SELECT COUNT(*) 
					FROM
				TerminationReasons r
			INNER JOIN
				EmployeeStatusHistory esh
			ON
				r.Value = esh.TerminationReason AND esh.StatusID = @terminatedId
			INNER JOIN Employee e on e.id= esh.EmployeeID
			LEFT OUTER JOIN EmployeePositionHistory eph on e.id= eph.EmployeeID AND eph.primaryposition = 'Y' AND
			((convert(datetime,eph.startdate) <= convert(datetime,esh.startdate) OR convert(datetime,eph.enddate) >= convert(datetime,esh.StartDate)) 
			OR (convert(datetime,eph.startdate) <= convert(datetime,esh.startdate) AND eph.enddate IS NULL))
			LEFT OUTER JOIN Position p on eph.PositionID= p.id
			WHERE
				e.identifier <> 'Vacant' 
				AND (convert(datetime,esh.StartDate) >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND convert(datetime,esh.StartDate) <= @date)
				AND esh.StatusID = @terminatedId
			AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
			AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
			AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
			AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))
		) as ItemCount
	UNION ALL
	SELECT
		r.Value as Item,
		ISNULL(rs.ItemCount, 0) AS ItemCount
	FROM
		TerminationReasons r
	LEFT OUTER JOIN
	(
		SELECT
			COUNT (*) as ItemCount,
			r.Value as ItemDesc
		FROM
			TerminationReasons r
		INNER JOIN
			EmployeeStatusHistory esh
		ON
			r.Value = esh.TerminationReason AND esh.StatusID = @terminatedId
		inner join Employee e on e.id= esh.EmployeeID
		left outer join EmployeePositionHistory eph on e.id= eph.EmployeeID and eph.primaryposition = 'Y' and
			((convert(datetime,eph.startdate) <= convert(datetime,esh.startdate) OR convert(datetime,eph.enddate) >= convert(datetime,esh.StartDate)) 
			OR (convert(datetime,eph.startdate) <= convert(datetime,esh.startdate) AND eph.enddate IS NULL))
		left outer join Position p on eph.PositionID= p.id 
		WHERE
			e.identifier <> 'Vacant' 
			and (convert(datetime,esh.StartDate) >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND convert(datetime,esh.StartDate ) <= @date)
			and esh.StatusID=@terminatedId
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
			AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
			AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))
		GROUP BY
			r.Value
	) AS rs
	ON
		rs.ItemDesc = r.Value
	--SELECT
	--	(SELECT COUNT(*) FROM Employee WHERE identifier <> 'Vacant' AND termination >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND termination <= @date) AS Total,
	--	(SELECT COUNT(*) FROM Employee WHERE identifier <> 'Vacant' AND termination >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND termination <= @date AND terminationreason = 'Resignation') AS Resignation,
	--	(SELECT COUNT(*) FROM Employee WHERE identifier <> 'Vacant' AND termination >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND termination <= @date AND terminationreason = 'Redundancy') AS Redundancy,
	--	(SELECT COUNT(*) FROM Employee WHERE identifier <> 'Vacant' AND termination >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND termination <= @date AND terminationreason = 'End of Contract') AS EndofContract,
	--	(SELECT COUNT(*) FROM Employee WHERE identifier <> 'Vacant' AND termination >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND termination <= @date AND terminationreason = 'Misconduct') AS Misconduct,
	--	(SELECT COUNT(*) FROM Employee WHERE identifier <> 'Vacant' AND termination >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND termination <= @date AND terminationreason = 'Performance') AS Performance,
	--	(SELECT COUNT(*) FROM Employee WHERE identifier <> 'Vacant' AND termination >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND termination <= @date AND terminationreason = 'Retirement') AS Retirement,
	--	(SELECT COUNT(*) FROM Employee WHERE identifier <> 'Vacant' AND termination >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND termination <= @date AND terminationreason = 'Death') AS Death,
	--	(SELECT COUNT(*) FROM Employee WHERE identifier <> 'Vacant' AND termination >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND termination <= @date AND terminationreason = 'Other') AS Other
END
