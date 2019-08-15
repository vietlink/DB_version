/****** Object:  Procedure [dbo].[uspGetEmpoloyeeHeadCountTrend]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmpoloyeeHeadCountTrend](@date datetime, @listDivision varchar(max), @listDepartment varchar(max), @listLocation varchar(max), @listEmployeeStatus varchar(max), @listEmployeeType varchar(max))
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
	SET NOCOUNT ON;

	SELECT
		(SELECT COUNT(DISTINCT e.ID)
		 FROM Employee e 
		 INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID 
		 LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		 LEFT OUTER join Position p on eph.PositionID=p.id
		 INNER JOIN Status s on esh.StatusID=s.Id
		WHERE e.identifier <> 'Vacant'  
		AND e.IsPlaceholder = 0 
		and eph.primaryposition='Y'
		AND EOMONTH(DateAdd(month, -11, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') 
		and e.status<>'Deleted'				
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -11, @date)), EOMONTH(DateAdd(month, -10, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -11, @date)), EOMONTH(DateAdd(month, -10, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -11, @date)), EOMONTH(DateAdd(month, -10, @date)), e.id)))								
		--and eph.id = (select max(id) from EmployeePositionHistory _ep where _ep.employeeid = e.id and _ep.primaryposition='Y' and DateAdd(month, -11, @date) between _ep.startdate and isnull(_ep.enddate, GETDATE()))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS One,
		(SELECT EOMONTH(DateAdd(month, -11, @date))) OneDate,

		(SELECT COUNT(DISTINCT e.ID) 
		FROM Employee e 
		INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER join Position p on eph.PositionID=p.id
		INNER JOIN Status s ON esh.StatusID= s.Id
		WHERE EOMONTH(DateAdd(month, -10, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') 
		AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		and e.status<>'Deleted'				
		and eph.primaryposition='Y'
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -10, @date)), EOMONTH(DateAdd(month, -9, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -10, @date)), EOMONTH(DateAdd(month, -9, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -10, @date)), EOMONTH(DateAdd(month, -9, @date)), e.id)))								
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS Two,
		(SELECT EOMONTH(DateAdd(month, -10, @date))) TwoDate,
		(SELECT COUNT(DISTINCT e.ID) 
		FROM Employee e 
		INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER join Position p on eph.PositionID=p.id
		INNER JOIN Status s ON esh.StatusID= s.Id
		WHERE EOMONTH(DateAdd(month, -9, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		and e.status<>'Deleted'				
		and eph.primaryposition='Y'
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -9, @date)), EOMONTH(DateAdd(month, -8, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -9, @date)), EOMONTH(DateAdd(month, -8, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -9, @date)), EOMONTH(DateAdd(month, -8, @date)), e.id)))								
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS Three,
		(SELECT EOMONTH(DateAdd(month, -9, @date))) ThreeDate,

		(SELECT COUNT(DISTINCT e.ID) 
		FROM Employee e 
		INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER join Position p on eph.PositionID=p.id
		INNER JOIN Status s ON esh.StatusID= s.Id
		WHERE EOMONTH(DateAdd(month, -8, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		and e.status<>'Deleted'				
		and eph.primaryposition='Y'
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -8, @date)), EOMONTH(DateAdd(month, -7, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -8, @date)), EOMONTH(DateAdd(month, -7, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -8, @date)), EOMONTH(DateAdd(month, -7, @date)), e.id)))								
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS Four,
		(SELECT EOMONTH(DateAdd(month, -8, @date))) FourDate,

		(SELECT COUNT(DISTINCT e.ID) 
		FROM Employee e 
		INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER join Position p on eph.PositionID=p.id
		INNER JOIN Status s ON esh.StatusID= s.Id
		WHERE EOMONTH(DateAdd(month, -7, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		and e.status<>'Deleted'			
		and eph.primaryposition='Y'	
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -7, @date)), EOMONTH(DateAdd(month, -6, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -7, @date)), EOMONTH(DateAdd(month, -6, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -7, @date)), EOMONTH(DateAdd(month, -6, @date)), e.id)))								
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS Five,
		(SELECT EOMONTH(DateAdd(month, -7, @date))) FiveDate,
		(SELECT COUNT(DISTINCT e.ID) 
		FROM Employee e 
		INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER join Position p on eph.PositionID=p.id
		INNER JOIN Status s ON esh.StatusID= s.Id
		WHERE EOMONTH(DateAdd(month, -6, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
		and e.status<>'Deleted'				
		and eph.primaryposition='Y'
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -6, @date)), EOMONTH(DateAdd(month, -5, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -6, @date)), EOMONTH(DateAdd(month, -5, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -6, @date)), EOMONTH(DateAdd(month, -5, @date)), e.id)))								
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS Six,
		(SELECT EOMONTH(DateAdd(month, -6, @date))) SixDate,

		(SELECT COUNT(DISTINCT e.ID) 
		FROM Employee e 
		INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER join Position p on eph.PositionID=p.id
		INNER JOIN Status s ON esh.StatusID= s.Id
		WHERE EOMONTH(DateAdd(month, -5, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		and e.status<>'Deleted'		
		and eph.primaryposition='Y'		
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -5, @date)), EOMONTH(DateAdd(month, -4, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -5, @date)), EOMONTH(DateAdd(month, -4, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -5, @date)), EOMONTH(DateAdd(month, -4, @date)), e.id)))								
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS Seven,
		(SELECT EOMONTH(DateAdd(month, -5, @date))) SevenDate,
		(SELECT COUNT(DISTINCT e.ID) 
		FROM Employee e 
		INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER join Position p on eph.PositionID=p.id
		INNER JOIN Status s ON esh.StatusID= s.Id
		WHERE EOMONTH(DateAdd(month, -4, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		and e.status<>'Deleted'			
		and eph.primaryposition='Y'	
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -3, @date)), EOMONTH(DateAdd(month, -4, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -3, @date)), EOMONTH(DateAdd(month, -4, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -3, @date)), EOMONTH(DateAdd(month, -4, @date)), e.id)))								
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS Eight,
		(SELECT EOMONTH(DateAdd(month, -4, @date))) EightDate,

		(SELECT COUNT(DISTINCT e.ID)
		 FROM Employee e 
		 INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID 
		 INNER JOIN Status s ON esh.StatusID= s.Id
		 LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID LEFT OUTER join Position p on eph.PositionID=p.id
		WHERE EOMONTH(DateAdd(month, -3, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		and e.status<>'Deleted'				
		and eph.primaryposition='Y'
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -3, @date)), EOMONTH(DateAdd(month, -2, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -3, @date)), EOMONTH(DateAdd(month, -2, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -3, @date)), EOMONTH(DateAdd(month, -2, @date)), e.id)))								
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS Nine,
		(SELECT EOMONTH(DateAdd(month, -3, @date))) NineDate,

		(SELECT COUNT(DISTINCT e.ID) 
		FROM Employee e INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID 
		INNER JOIN Status s ON esh.StatusID= s.Id
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID LEFT OUTER join Position p on eph.PositionID=p.id
		WHERE EOMONTH(DateAdd(month, -2, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		and e.status<>'Deleted'				
		and eph.primaryposition='Y'
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -2, @date)), EOMONTH(DateAdd(month, -1, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -2, @date)), EOMONTH(DateAdd(month, -1, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -2, @date)), EOMONTH(DateAdd(month, -1, @date)), e.id)))								
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS Ten,
		(SELECT EOMONTH(DateAdd(month, -2, @date))) TenDate,
		(SELECT COUNT(DISTINCT e.ID)
		FROM Employee e INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID INNER JOIN Status s ON esh.StatusID= s.Id
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID LEFT OUTER join Position p on eph.PositionID=p.id
		WHERE EOMONTH(DateAdd(month, -1, @date)) BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		and e.status<>'Deleted'				
		and eph.primaryposition='Y'
		AND (s.Code!='D' AND s.Code!='T')
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -1, @date)), EOMONTH(DateAdd(month, 0, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, -1, @date)), EOMONTH(DateAdd(month, 0, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, -1, @date)), EOMONTH(DateAdd(month, 0, @date)), e.id)))								
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))) AS Eleven,
		(SELECT EOMONTH(DateAdd(month, -1, @date))) ElevenDate,
		(SELECT COUNT(DISTINCT e.ID) 
		FROM Employee e INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.ID INNER JOIN Status s ON esh.StatusID= s.Id
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID LEFT OUTER join Position p on eph.PositionID=p.id
		WHERE @date BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2200-01-01') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		and eph.primaryposition='Y'
		and ((eph.id = dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, 0, @date)), EOMONTH(DateAdd(month, 1, @date)), e.id)) or dbo.fnGetEmpPositionIDInPeriod(EOMONTH(DateAdd(month, 0, @date)), EOMONTH(DateAdd(month, 1, @date)), e.id)=0)
		and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(EOMONTH(DateAdd(month, 0, @date)), EOMONTH(DateAdd(month, 1, @date)), e.id)))								
		AND (s.Code!='D' AND s.Code!='T')
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
				AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
				AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS Twelve,
		(SELECT @date) TwelveDate
	
END
