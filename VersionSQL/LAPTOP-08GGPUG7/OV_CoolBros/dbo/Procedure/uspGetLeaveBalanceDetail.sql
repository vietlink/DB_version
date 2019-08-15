/****** Object:  Procedure [dbo].[uspGetLeaveBalanceDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveBalanceDetail] 
	-- Add the parameters for the stored procedure here
	 (@dateTo datetime, @divisionFilterList varchar(max), @departmentFilterList varchar(max), @locationFilterList varchar(max), @leaveTypeFilter varchar(max), @employeeTypeFilter varchar(max), @employeeStatusFilter varchar(max), @sortBy varchar(max), @groupBy varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @idDepartmentTable TABLE(idDepartment varchar(max));
	DECLARE @idDivisionTable TABLE(idDivision varchar(max));
	DECLARE @idLocationTable TABLE(idLocation varchar(max));
	DECLARE @leaveTypeTable TABLE(leaveType varchar(max));
	declare @employeeTypeTable table(employeeType varchar(max));
	declare @employeeStatusTable table(employeeStatus varchar(max));
	--create table #employeeTable (id int, displayname varchar(50), surname varchar(50), location varchar(50), type varchar(50), status varchar(50));
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

	IF CHARINDEX(';', @leaveTypeFilter, 0) > 0 BEGIN
		INSERT INTO @leaveTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@leaveTypeFilter, ';');	
    END
    ELSE IF LEN(@leaveTypeFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @leaveTypeTable(leaveType) VALUES(@leaveTypeFilter);	
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

	select e.id, e.displayname, e.surname, e.location, e.type, e.status, p.orgunit2, p.orgunit3, p.title into #employeeTable 
	from Employee e
	inner join EmployeePosition ep on ep.employeeid= e.id
	inner join Position p on p.id= ep.positionid	
	where ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable))
		AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @idLocationTable))
		and ep.primaryposition='Y' and ep.IsDeleted=0
		and ep.vacant='N'
		and e.IsPlaceholder!=1	

	select lat.EmployeeID, lt.ReportDescription, lat.DateFrom, lat.ID,
	lat.Balance,
	RANK() over(partition by lat.EmployeeID, lat.leavetypeid order by lat.id desc) as ranking, ewh.SalaryBase, ewh.DateFrom as startDate, ewh.DateTo 
	into #temp
	from LeaveAccrualTransactions lat 
	inner join LeaveType lt on lat.LeaveTypeID= lt.ID
	inner join EmployeeWorkHoursHeader ewh on ewh.EmployeeID=lat.EmployeeID
	where 
	lat.DateFrom<=@dateTo	
	and ((lat.DateFrom>=ewh.DateFrom and lat.DateFrom<=ewh.DateTo) or (lat.DateFrom>=ewh.DateFrom and ewh.DateTo is null))
	AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR lt.[ReportDescription] IN (SELECT * FROM @leaveTypeTable))				
	
	select * into #transactionTable
	from #temp 
	where ranking=1		
	--select * from #transactionTable
	SELECT 
		e.id as EmployeeID,	
		e.displayname as displayname,
		e.orgunit2 as orgunit2,
		e.orgunit3 as orgunit3,
		e.location as location,
		e.title as title,
		lat.ReportDescription as LeaveType,
		lat.DateFrom,
		lat.SalaryBase as salarybase,
		lat.Balance	
	from #employeeTable e 	
		inner join #transactionTable lat 
		on e.id= lat.EmployeeID		
	ORDER BY		
		CASE WHEN @groupBy = 'orgunit2' THEN e.orgunit2 END,		
		CASE WHEN @groupBy = 'orgunit3' THEN e.orgunit3 END,
		CASE WHEN @groupBy = 'location' THEN e.location END,		
		CASE WHEN @sortBy = 'orgunit2' THEN e.orgunit2 END,
		CASE WHEN @sortBy = 'orgunit3' THEN e.orgunit3 END,
		CASE WHEN @sortBy = 'displayname' THEN e.displayname END,
		CASE WHEN @sortBy = 'surname' THEN e.surname END,		
		e.displayname, lat.ReportDescription	

	if (OBJECT_ID('tempdb..#employeeTable') is not null)
	begin 
		drop table #employeeTable
	end
	if (OBJECT_ID('tempdb..#temp') is not null)
	begin 
		drop table #temp
	end
	if (OBJECT_ID('tempdb..#transacstionTable') is not null)
	begin 
		drop table #transactionTable
	end
END
