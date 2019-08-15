/****** Object:  Procedure [dbo].[uspGetWhoManageWho]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWhoManageWho] 
	-- Add the parameters for the stored procedure here	  
	(@divisionFilterList varchar(max), @departmentFilterList varchar(max), @locationFilterList varchar(max), @employeeTypeFilter varchar(max),@employeeStatusFilter varchar(max), @sortBy varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @idDepartmentTable TABLE(idDepartment varchar(max));
	DECLARE @idDivisionTable TABLE(idDivision varchar(max));
	DECLARE @idLocationTable TABLE(idLocation varchar(max));
	DECLARE @employeeTypeTable TABLE(employeeType varchar(max));
	DECLARE @employeeStatusTable TABLE(employeeStatus varchar(max));
	
	IF CHARINDEX(',', @divisionFilterList, 0) > 0 BEGIN
		INSERT INTO @idDivisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionFilterList, ',');	
    END
    ELSE IF LEN(@divisionFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDivisionTable(idDivision) VALUES(@divisionFilterList);	
    END

	IF CHARINDEX(',', @departmentFilterList, 0) > 0 BEGIN
		INSERT INTO @idDepartmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentFilterList, ',');	
    END
    ELSE IF LEN(@departmentFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDepartmentTable(idDepartment) VALUES(@departmentFilterList);	
    END

	IF CHARINDEX(';', @locationFilterList, 0) > 0 BEGIN
		INSERT INTO @idLocationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationFilterList, ';');	
    END
    ELSE IF LEN(@locationFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idLocationTable(idLocation) VALUES(@locationFilterList);	
    END

	IF CHARINDEX(',', @employeeTypeFilter, 0) > 0 BEGIN
		INSERT INTO @employeeTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@employeeTypeFilter, ',');	
    END
    ELSE IF LEN(@employeeTypeFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeTypeTable(employeeType) VALUES(@employeeTypeFilter);	
    END	

	IF CHARINDEX(',', @employeeStatusFilter, 0) > 0 BEGIN
		INSERT INTO @employeeStatusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@employeeStatusFilter, ',');	
    END
    ELSE IF LEN(@employeeStatusFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeStatusTable(employeeStatus) VALUES(@employeeStatusFilter);	
    END	
    -- Insert statements for procedure here	
select * from (
	select 
		e.id as EmpID,
		e.displayname as Name,
		e.surname as SurName,
		p.title as Title,
		p.orgunit2 as orgunit2,
		p.orgunit3 as orgunit3,
		e.location as location,
		e.status as status,
		e.type as empType,
		eM.id as ManagerID,
		eM.displayname as ManagerName,
		pM.description as ManagerTitle,
		pM.orgunit2 as Managerorgunit2,		
		pM.orgunit3 as Managerorgunit3,		
		eM.location as Managerlocation,		
		eM.status as Managerstatus,
		eM.type as Managertype, 	
		s.Code as ManagerstatusCode,
		1 as hasManager	
	from 
	Employee e
	inner join EmployeePosition ep on e.id= ep.employeeid
	inner join Position p on p.id= ep.positionid
	inner join EmployeePosition epM on ep.ManagerID= epM.id
	inner join Employee eM on epM.employeeid= eM.id
	inner join Position pM on epM.positionid= pM.id	
	inner join Status s on eM.status= s.Description
	where 
	ep.primaryposition='Y' and ep.isdeleted = 0 	
	and epM.primaryposition='Y' and epM.isdeleted = 0 
	and ep.vacant='N'
	and e.IsPlaceholder!=1
	and ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR pM.orgunit3 IN (SELECT * FROM @idDepartmentTable))
	AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR pM.orgunit2 IN (SELECT * FROM @idDivisionTable))
	AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR eM.location IN (SELECT * FROM @idLocationTable))
	AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
	AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))	
UNION
	SELECT
		e.id as EmpID,
		e.displayname as Name,
		e.surname as SurName,
		p.title as Title,
		p.orgunit2 as orgunit2,
		p.orgunit3 as orgunit3,
		e.location as location,
		e.status as status,
		e.type as empType,
		ep.ManagerID as ManagerID,
		 '' as ManagerName,
		'' as ManagerTitle,
		'' as Managerorgunit2,		
		'' as Managerorgunit3,		
		'' as Managerlocation,		
		'' as Managerstatus,
		'' as Managertype,
		'' as ManagerstatusCode,
		0 as hasManager
	FROM
		Employee e
		INNER JOIN EmployeePosition ep ON e.id= ep.employeeid
		INNER JOIN Position p ON ep.positionid= p.id
	WHERE 
		ep.primaryposition='Y' and ep.IsDeleted=0
		and ep.ManagerID is null		
		and ep.vacant='N'
		and e.IsPlaceholder!=1
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))) as Result	
	ORDER BY
		Result.ManagerName,
		CASE WHEN @sortBy='name' THEN Result.Name END,
		CASE WHEN @sortBy='surname' THEN Result.SurName END
				
END

