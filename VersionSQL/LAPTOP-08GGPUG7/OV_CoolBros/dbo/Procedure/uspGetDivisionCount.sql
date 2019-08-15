/****** Object:  Procedure [dbo].[uspGetDivisionCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDivisionCount](@date datetime, @listDivision varchar(max), @listDepartment varchar(max), @listLocation varchar(max), @listEmployeeStatus varchar(max), @listEmployeeType varchar(max))

AS
BEGIN
	declare @divisionTable table (idDivisionTable varchar(max));
	declare @departmentTable table (idDepartmentTable varchar(max));
	declare @locationTable table (idLocationTable varchar(max));	
	declare @employeeStatusTable table (idEmployeeStatusTable varchar(max));
	declare @employeeTypeTable table (idEmployeeTypeTable varchar(max));	

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
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @vacantId int;
	SELECT @vacantId = id FROM Employee WHERE identifier = 'vacant'
	SELECT 
		rs.division,
		count(rs.division) as [count] FROM 
			(SELECT 
					isnull(p.orgunit2, '') as division 
				FROM 
					EmployeePositionHistory ep
				INNER JOIN Position p
				ON
					ep.positionid = p.id
				INNER JOIN
					Employee e
				ON
					e.id = ep.employeeid
				INNER JOIN 
					EmployeeStatusHistory esh
				ON
					esh.employeeid = e.id
				INNER JOIN
					[Status] s
				ON
					s.id = esh.StatusID
				WHERE e.IsPlaceholder = 0 AND p.IsPlaceholder = 0 AND ep.employeeid <> @vacantId AND @date BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2222-01-01') 
				and ep.id = (select max(id) from EmployeePositionHistory _ep where _ep.employeeid = e.id and _ep.primaryposition='Y' and @date between _ep.startdate and isnull(_ep.enddate, GETDATE()))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			) AS rs
		 GROUP BY rs.division
		 ORDER BY rs.division
END
