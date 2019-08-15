/****** Object:  Procedure [dbo].[uspGetTurnoverReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTurnoverReport] 
	-- Add the parameters for the stored procedure here
	(@date varchar(max), @divisionFilterList varchar(max), @departmentFilterList varchar(max), @locationFilterList varchar(max), @employeeTypeFilter varchar(max),@employeeStatusFilter varchar(max), @groupBy varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
	DECLARE @DateTable Table(dateTo datetime);
	DECLARE @idDepartmentTable TABLE(idDepartment varchar(max));
	DECLARE @idDivisionTable TABLE(idDivision varchar(max));
	DECLARE @idLocationTable TABLE(idLocation varchar(max));
	DECLARE @employeeTypeTable TABLE(employeeType varchar(max));
	DECLARE @employeeStatusTable TABLE(employeeStatus varchar(max));		
	declare @count int;
	declare @result table(dateTo datetime, groupby varchar(max), total decimal, _close decimal, newStarter decimal, terminated decimal);
	
	IF CHARINDEX(',', @date, 0) > 0 BEGIN
		INSERT INTO @DateTable
		SELECT convert(datetime, splitdata, 103) FROM fnSplitString(@date, ',');	
    END
    ELSE IF LEN(@date) > 0 BEGIN 
		INSERT INTO @DateTable(dateTo) VALUES(convert(datetime, @date, 103));	
    END	
	IF CHARINDEX(',', @divisionFilterList, 0) > 0 BEGIN
		INSERT INTO @idDivisionTable 
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionFilterList, ',');	
    END
    ELSE IF LEN(@divisionFilterList) > 0 BEGIN 
		INSERT INTO @idDivisionTable(idDivision) VALUES(@divisionFilterList);	
    END
	
	IF CHARINDEX(',', @departmentFilterList, 0) > 0 BEGIN
		INSERT INTO @idDepartmentTable
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentFilterList, ',');	
    END
    ELSE IF LEN(@departmentFilterList) > 0 BEGIN 
		INSERT INTO @idDepartmentTable(idDepartment) VALUES(@departmentFilterList);	
    END

	IF CHARINDEX(';', @locationFilterList, 0) > 0 BEGIN
		INSERT INTO @idLocationTable
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationFilterList, ';');	
    END
    ELSE IF LEN(@locationFilterList) > 0 BEGIN 
		INSERT INTO @idLocationTable(idLocation) VALUES(@locationFilterList);	
    END

	IF CHARINDEX(',', @employeeTypeFilter, 0) > 0 BEGIN
		INSERT INTO @employeeTypeTable 
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@employeeTypeFilter, ',');	
    END
    ELSE IF LEN(@employeeTypeFilter) > 0 BEGIN 
		INSERT INTO @employeeTypeTable(employeeType) VALUES(@employeeTypeFilter);	
    END	

	IF CHARINDEX(',', @employeeStatusFilter, 0) > 0 BEGIN
		INSERT INTO @employeeStatusTable
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@employeeStatusFilter, ',');	
    END
    ELSE IF LEN(@employeeStatusFilter) > 0 BEGIN 
		INSERT INTO @employeeStatusTable(employeeStatus) VALUES(@employeeStatusFilter);	
    END	
	select ROW_NUMBER() over (order by dateto ) as id, dateto into #temp1 from @DateTable --
	declare @counter int= (select count(*) from #temp1);	
	declare @round int;
	declare @groupByValue varchar(max);
	declare @from datetime;
	declare @to datetime;
	-- no group by selected
	if (@groupBy='')
	begin
		while (@counter>=1)
		begin 				
			set @to = (select dateto from #temp1 where #temp1.id=@counter);
			if (@counter>1)	begin 
				set @from = (select dateto from #temp1 where #temp1.id=@counter-1) ;
			end;		
			if (@counter=1) begin
				set @from=@to;
			end					
			--Get all employee who match with the filters with their status within the period
			select e.id, s.Code, e.commencement, esh.StartDate, esh.EndDate  into #tempEmp0
					FROM Employee e
					left outer join EmployeePositionHistory ep on e.id= ep.employeeid
					left outer join position p on ep.positionid= p.id
					INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.id		
					inner join Status s on esh.StatusID= s.Id	
					WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0		
					and e.status<>'Deleted'				
					and ((ep.id = dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id) And dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id)!=0) or dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id)=0)
					and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(@from, @to, e.id) And dbo.fnGetEmpStatusIDInPeriod(@from, @to, e.id)!=0))								
					AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
					AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable))
					AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR e.location IN (SELECT * FROM @idLocationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))

			declare @total decimal;
			set @total=(isnull (cast((SELECT COUNT(distinct t.id) FROM #tempEmp0 t WHERE t.Code!='T' and t.Code!='D' and t.commencement!=@to) as decimal), 0.0)); -- count employee who is not terminated or deleted and not start at the end of the period
			
			declare @newStarter decimal;
			set @newStarter= isnull(cast((SELECT COUNT( distinct t.id) FROM #tempEmp0 t WHERE t.commencement >= @from and t.commencement< @to) as decimal), 0.0); -- count employee who is started within the period
						
			declare @terminated decimal;		
			set @terminated= isnull(cast((SELECT COUNT(distinct t.id) FROM #tempEmp0 t 
					WHERE ((t.StartDate >=@from and t.EndDate< @to) or (t.StartDate >= @from and t.StartDate<@to and t.EndDate is null))
					and t.Code='T') as decimal),0.0); -- count employee who has terminated status within the period 
			
			insert into @result values( @to,'', @total-@newStarter+@terminated /*the number of employee at the start of the period*/,@total /*the number of employee at the end of the period*/, @newStarter, @terminated);
			set @counter= @counter-1;
			if (OBJECT_ID('tempdb..#tempEmp0') is not null)			
						drop table #tempEmp0
		end	
	end
	--group by division
	if (@groupBy='posorgunit2')
	begin		
		set @round= (select count(distinct p.orgunit2) 
		from Position p inner join EmployeePosition ep on p.id= ep.positionid
		where ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable))); -- count the number of division that match the filter

		select distinct ISNULL(p.orgunit2,'') as orgunit2, DENSE_RANK() over(order by isnull(p.orgunit2,'') desc) as id into #groupByTable 
		from Position p inner join EmployeePosition ep on p.id= ep.positionid
		where ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable)); -- get the name of the existed division for later comparison					

		while (@round>=1)-- count the number of employee in each division for each period using the same logic above
		begin
			set @groupByValue= (select g.orgunit2 from #groupByTable g where g.id=@round);				
			while (@counter>=1)
			begin 				
				set @to = (select dateto from #temp1 where #temp1.id=@counter);
				if (@counter>1)	begin 
					set @from = (select dateto from #temp1 where #temp1.id=@counter-1) ;
				end;				
				if (@counter=1)
					set @from = 0 ;
				
				select e.id, s.Code, e.commencement, esh.StartDate, esh.EndDate  into #tempEmp
				FROM Employee e
				left outer join EmployeePositionHistory ep on e.id= ep.employeeid
				left outer join position p on ep.positionid= p.id
				INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.id		
				inner join Status s on esh.StatusID= s.Id	
				WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0		
				and e.status<>'Deleted'				
			    and ((ep.id = dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id) And dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id)!=0) or dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id)=0)
				and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(@from, @to, e.id) And dbo.fnGetEmpStatusIDInPeriod(@from, @to, e.id)!=0))
				and isnull(p.orgunit2,'')=@groupByValue				
				AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR e.location IN (SELECT * FROM @idLocationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable));
				
				declare @total1 decimal;
				set @total1=(isnull (cast((SELECT COUNT(distinct t.id) FROM #tempEmp t WHERE t.Code!='T' and t.Code!='D' and t.commencement!=@to) as decimal), 0.0)) ;
		
				declare @newStarter1 decimal;
				set @newStarter1= isnull(cast((SELECT COUNT( distinct t.id) FROM #tempEmp t	WHERE t.commencement >=@from and t.commencement< @to) as decimal), 0.0);
						
				declare @terminated1 decimal;		
				set @terminated1= isnull(cast((SELECT COUNT(distinct t.id) FROM #tempEmp t 
				WHERE ((t.StartDate >=@from and t.EndDate< @to) or (t.StartDate >= @from and t.StartDate<@to and t.EndDate is null))
				and t.Code='T') as decimal),0.0);
			
				insert into @result values(@to,@groupByValue, @total1-@newStarter1+@terminated1,@total1, @newStarter1, @terminated1);
				set @counter= @counter-1;
				if (OBJECT_ID('tempdb..#tempEmp') is not null)			
					drop table #tempEmp
			end	
			set @round=@round-1;
			set @counter=(select count(*) from #temp1);					
		end
		if (OBJECT_ID('tempdb..#groupByTable') is not null)			
			drop table #groupByTable		
	end	
	--group by department
	if (@groupBy='posorgunit3')
	begin
		
		set @round= (select count(distinct p.orgunit3) 
					from Position p inner join EmployeePosition ep on p.id= ep.positionid
					where ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
				AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable)));

		select distinct ISNULL(p.orgunit3,'') as orgunit3, DENSE_RANK() over(order by isnull(p.orgunit3,'') desc) as id into #groupByTable1 
		from Position p inner join EmployeePosition ep on p.id= ep.positionid
		where ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable));	
			
		while (@round>=1)
		begin
			set @groupByValue= (select g.orgunit3 from #groupByTable1 g where g.id=@round);				
			while (@counter>=1)
				begin 				
					set @to = (select dateto from #temp1 where #temp1.id=@counter);
					if (@counter>1)	begin 
						set @from = (select dateto from #temp1 where #temp1.id=@counter-1) ;
					end;				
					if (@counter=1)
						set @from = 0 ;
					select e.id, s.Code, e.commencement, esh.StartDate, esh.EndDate  into #tempEmp1
					FROM Employee e
					left outer join EmployeePositionHistory ep on e.id= ep.employeeid
					left outer join position p on ep.positionid= p.id
					INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.id		
					inner join Status s on esh.StatusID= s.Id	
					WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0		
					and e.status<>'Deleted'				
					and ((ep.id = dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id) And dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id)!=0) or dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id)=0)
					and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(@from, @to, e.id) And dbo.fnGetEmpStatusIDInPeriod(@from, @to, e.id)!=0))
					and isnull(p.orgunit3,'')=@groupByValue				
					AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR e.location IN (SELECT * FROM @idLocationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable));
					declare @total2 decimal;
					set @total2=(isnull (cast((SELECT COUNT(distinct t.id) FROM #tempEmp1 t WHERE t.Code!='T' and t.Code!='D' and t.commencement!=@to) as decimal), 0.0)) ;
		
					declare @newStarter2 decimal;
					set @newStarter2= isnull(cast((SELECT COUNT( distinct t.id) FROM #tempEmp1 t WHERE t.commencement >=@from and t.commencement< @to) as decimal), 0.0);
						
					declare @terminated2 decimal;		
					set @terminated2= isnull(cast((SELECT COUNT(distinct t.id) FROM #tempEmp1 t 
					WHERE ((t.StartDate >=@from and t.EndDate< @to) or (t.StartDate >= @from and t.StartDate<@to and t.EndDate is null))
					and t.Code='T') as decimal),0.0);
					insert into @result values(@to,@groupByValue, @total2-@newStarter2+@terminated2, @total2, @newStarter2, @terminated2);
					set @counter= @counter-1;
					if (OBJECT_ID('tempdb..#tempEmp1') is not null)			
						drop table #tempEmp1
				end	
			set @round=@round-1;
			set @counter=(select count(*) from #temp1);		
		end
		if (OBJECT_ID('tempdb..#groupByTable1') is not null)			
				drop table #groupByTable1
	end	
	--group by location
	if (@groupBy='location')
	begin		
		set @round= (select count(distinct p.location) 
		from Employee p inner join EmployeePosition ep on p.id= ep.positionid
		where ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR p.location IN (SELECT * FROM @idLocationTable)));
		
		select distinct isnull(p.location,'') as location, DENSE_RANK() over(order by isnull(p.location,'') desc) as id into #groupByTable2 
		from Employee p inner join EmployeePosition ep on p.id= ep.positionid
		where ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR p.location IN (SELECT * FROM @idLocationTable))
		while (@round>=1)
		begin
			set @groupByValue= (select g.location from #groupByTable2 g where g.id=@round);				
			while (@counter>=1)
			begin 				
				set @to = (select DATEADD(day,1, dateto) from #temp1 where #temp1.id=@counter);
				if (@counter>1)	begin 
					set @from = (select dateto from #temp1 where #temp1.id=@counter-1) ;
				end;				
				if (@counter=1)
					set @from = 0 ;
				select e.id, s.Code, e.commencement, esh.StartDate, esh.EndDate  into #tempEmp2
				FROM Employee e
				left outer join EmployeePositionHistory ep on e.id= ep.employeeid
				left outer join position p on ep.positionid= p.id
				INNER JOIN EmployeeStatusHistory esh ON esh.EmployeeID = e.id		
				inner join Status s on esh.StatusID= s.Id	
				WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0		
				and e.status<>'Deleted'				
			    and ((ep.id = dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id) And dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id)!=0) or dbo.fnGetEmpPositionIDInPeriod(@from, @to, e.id)=0)
				and ((esh.id = dbo.fnGetEmpStatusIDInPeriod(@from, @to, e.id) And dbo.fnGetEmpStatusIDInPeriod(@from, @to, e.id)!=0))
				and isnull(e.location,'')=@groupByValue				
				AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
				AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable))				
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))
				declare @total3 decimal;
				set @total3=(isnull (cast((SELECT COUNT(distinct t.id) FROM #tempEmp2 t WHERE t.Code!='T' and t.Code!='D' and t.commencement!=@to) as decimal), 0.0)) ;
		
				declare @newStarter3 decimal;
				set @newStarter3= isnull(cast((SELECT COUNT( distinct t.id) FROM #tempEmp2 t WHERE t.commencement >=@from and t.commencement> @to) as decimal), 0.0);
						
				declare @terminated3 decimal;		
				set @terminated3= isnull(cast((SELECT COUNT(distinct t.id) FROM #tempEmp2 t				
				WHERE ((t.StartDate >=@from and t.EndDate< @to) or (t.StartDate >= @from and t.StartDate<@to and t.EndDate is null))
				and t.Code='T') as decimal),0.0);			
				insert into @result values(DATEADD(day,-1, @to),@groupByValue, @total3-@newStarter3+@terminated3,@total3, @newStarter3, @terminated3);
				set @counter= @counter-1;
				if (OBJECT_ID('tempdb..#tempEmp2') is not null)			
					drop table #tempEmp2
			end	
			set @round=@round-1;
			set @counter=(select count(*) from #temp1);		
		end
		if (OBJECT_ID('tempdb..#groupByTable2') is not null)			
			drop table #groupByTable2
	end		
	if (OBJECT_ID('tempdb..#temp1') is not null)			
		drop table #temp1			
	select * from @result 			
END
