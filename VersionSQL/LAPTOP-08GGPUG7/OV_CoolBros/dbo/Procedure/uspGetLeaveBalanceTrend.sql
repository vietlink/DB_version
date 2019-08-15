/****** Object:  Procedure [dbo].[uspGetLeaveBalanceTrend]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveBalanceTrend] 
	-- Add the parameters for the stored procedure here
	 (@date varchar(max), @leavetype varchar(50), @divisionFilterList varchar(max), @departmentFilterList varchar(max), @locationFilterList varchar(max), @employeeTypeFilter varchar(max),@employeeStatusFilter varchar(max), @groupBy varchar(max))
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
	declare @from datetime;
	declare @to datetime;
	declare @total decimal (25,15);
	declare @total_workhour decimal (25,15);
	declare @leaveperyear decimal (10,5);
	declare @count int;
	declare @defaultWorkHour varchar(4000) = (select s.value from Setting s where s.code='StandardWorkingHoursPerWeek');
	declare @defaultWorkHourPerDay varchar(4000) = (select s.value from Setting s where s.code='StandardWorkingDay');

	IF CHARINDEX(',', @date, 0) > 0 BEGIN
		INSERT INTO @DateTable-- split the text by , and store in temp table
		SELECT convert(datetime, splitdata, 103) FROM fnSplitString(@date, ',');	
    END
    ELSE IF LEN(@date) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @DateTable(dateTo) VALUES(convert(datetime, @date, 103));	
    END	
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
	--Get all employee match with the filter	
	--select e.id, e.displayname, e.surname, isnull(e.location,'')as location, e.type, e.status, isnull(p.orgunit2,'') as orgunit2, isnull(p.orgunit3,'') as orgunit3, p.title into #employeeTable 
	--from Employee e
	--inner join EmployeePosition ep on ep.employeeid= e.id
	--inner join Position p on p.id= ep.positionid		
	--where ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
	--	AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
	--	AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
	--	AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable))
	--	AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR e.location IN (SELECT * FROM @idLocationTable))
	--	and ep.primaryposition='Y' and ep.IsDeleted=0
	--	and ep.vacant='N'
	--	and e.IsPlaceholder!=1				
		--and e.id=21
	--select * from #employeeTable
	select ROW_NUMBER() over (order by dateto ) as id, dateto into #temp1 from @DateTable
	declare @result table (_date datetime, leaveAvg decimal(25,15), groupBy varchar(max),leaveEntitlement decimal(25,15));		
	declare @counter int= (select count(*) from #temp1);
	declare @A decimal(25,15);
	if (@groupBy='') begin
		while (@counter >=1)
		begin
			set @to = (select dateto from #temp1 where #temp1.id=@counter);
			if (@counter>1)	begin 
				set @from = (select dateto from #temp1 where #temp1.id=@counter-1) ;
			end;				
			if (@counter=1)
				set @from = 0 ;							
			--get all employee that active 					
			select e.id, isnull(e.location,'')as location, e.type, e.status, isnull(p.orgunit2,'') as orgunit2, isnull(p.orgunit3,'') as orgunit3, 			
			case when dbo.fnGetSumWorkHourByDay (e.id, @to)/ewh.WeekMode>@defaultWorkHour then @defaultWorkHour else dbo.fnGetSumWorkHourByDay (e.id, @to) end as total_workhour, 
			ewh.WeekMode as WeekMode into #employeeTemp 
			from Employee e
			inner join EmployeePositionHistory ep on ep.employeeid= e.id
			inner join Position p on p.id= ep.positionid		
			inner join EmployeeWorkHoursHeader ewh on ewh.EmployeeID= e.id
			inner join EmployeeWorkHours ew on ewh.ID= ew.EmployeeWorkHoursHeaderID
			where 			
			@to between ewh.DateFrom and isnull(ewh.DateTo, getdate())
			and @to between ep.startdate and ISNULL(ep.enddate, GETDATE())
			and ewh.ID= dbo.fnGetWorkHourHeaderIDByDay (e.id, @to)
			and ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
			AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
			AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
			AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable))
			AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @idLocationTable))
			and ep.primaryposition='Y' 
			and ep.vacant='N'
			and e.IsPlaceholder!=1				
			group by e.id, e.location, e.type, e.status, p.orgunit2, p.orgunit3, ewh.WeekMode

			--select * from #employeeTemp
			--get the leavea balance of each employee in that period
			select lat.id, lat.EmployeeID, lt.ReportDescription, lat.DateFrom, lat.LeaveTypeID,lat.Balance, lt.LeavePerYear,
			RANK() over(partition by lat.EmployeeID order by lat.id desc) as ranking
			into #temp
			from LeaveAccrualTransactions lat 
			inner join LeaveType lt on lat.LeaveTypeID= lt.ID	
			inner join #employeeTemp e on lat.EmployeeID=e.id		
			where 		
			lt.Code= @leavetype
			and lat.DateFrom<=@to and lat.DateFrom>@from;	
			
			select  * into #transactionTable from #temp where ranking=1 ;			
			--
			--select * from #transactionTable
			select @count=count(distinct #transactionTable.EmployeeID) from #transactionTable;							
			select @total= sum(lat.balance) from #transactionTable lat;							
		
			select e.WeekMode, 			
				e.total_workhour*t.LeavePerYear/(e.WeekMode*@defaultWorkHour) as _total,			
			t.LeaveTypeID into #t 
			from #employeeTemp e 
			inner join #transactionTable t on e.id= t.EmployeeID  
						
			--select * from #t																				
			set @A= (select sum(_tempResult)/@count from
			(
				select #t.WeekMode, sum(#t._total) as _tempResult 
				from #t group by #t.WeekMode) as result
			);
			insert into @result values(@to,isnull(@total/@count,0.0), null,isnull(@A*@defaultWorkHourPerDay,0.0));
			set @counter= @counter-1;
			if (OBJECT_ID('tempdb..#temp') is not null)
			begin 
				drop table #temp
			end
			if (OBJECT_ID('tempdb..#t') is not null)
			begin 
				drop table #t
			end
			
			if (OBJECT_ID('tempdb..#employeeTemp') is not null)
			begin 
				drop table #employeeTemp
			end			
			if (OBJECT_ID('tempdb..#transactionTable') is not null)
			begin 
				drop table #transactionTable
			end					
		end		
		select * from @result		
	end	
	if (@groupBy !='') begin 
		declare @round int;		
		declare @groupByValue varchar(max);
		if (@groupBy = 'posorgunit2') begin
			set @round= (select count(distinct p.orgunit2) from Position p inner join EmployeePosition ep on p.id= ep.positionid
			where ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
			AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable)));
			select distinct ISNULL(p.orgunit2,'') as orgunit2, DENSE_RANK() over(order by isnull(p.orgunit2,'') desc) as id into #groupByTable 
			from Position p inner join EmployeePosition ep on p.id= ep.positionid
			where ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
			AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable));					
			while (@round>=1) 
			begin				
				set @groupByValue= (select isnull(g.orgunit2,'') from #groupByTable g where g.id=@round);		
				print @groupByValue			
				while (@counter >=1) 
				begin 						
					set @to = (select dateto from #temp1 where #temp1.id=@counter);
					if (@counter>1)	
						set @from = (select dateto from #temp1 where #temp1.id=@counter-1) ;						
					if (@counter=1)
						set @from = 0 ;
														
					select e.id, isnull(e.location,'')as location, e.type, e.status, isnull(p.orgunit2,'') as orgunit2, isnull(p.orgunit3,'') as orgunit3, 			
						case when dbo.fnGetSumWorkHourByDay (e.id, @to)/ewh.WeekMode>@defaultWorkHour then @defaultWorkHour else dbo.fnGetSumWorkHourByDay (e.id, @to) end as total_workhour, 
						ewh.WeekMode as WeekMode into #employeeTemp1 
					from Employee e
						inner join EmployeePositionHistory ep on ep.employeeid= e.id
						inner join Position p on p.id= ep.positionid		
						inner join EmployeeWorkHoursHeader ewh on ewh.EmployeeID= e.id
						inner join EmployeeWorkHours ew on ewh.ID= ew.EmployeeWorkHoursHeaderID
					where 			
						@to between ewh.DateFrom and isnull(ewh.DateTo, getdate())
						and @to between ep.startdate and ISNULL(ep.enddate, GETDATE())
						and ewh.ID= dbo.fnGetWorkHourHeaderIDByDay (e.id, @to)
						and ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
						AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
						AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
						AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable))
						AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @idLocationTable))
						and ep.primaryposition='Y' 
						and ep.vacant='N'
						and e.IsPlaceholder!=1				
						and p.orgunit2=@groupByValue
					group by e.id, e.location, e.type, e.status, p.orgunit2, p.orgunit3, e.title, ewh.WeekMode
					;
					
					select lat.EmployeeID, lt.ReportDescription, lat.DateFrom, lat.LeaveTypeID,lat.Balance,e.orgunit2, lt.LeavePerYear,
						RANK() over(partition by lat.EmployeeID, lat.leavetypeid order by lat.id desc) as ranking
					into #temp2
					from LeaveAccrualTransactions lat 
						inner join LeaveType lt on lat.LeaveTypeID= lt.ID	
						inner join #employeeTemp1 e on lat.EmployeeID=e.id		
					where 		
						lt.Code= @leavetype
						and lat.DateFrom<=@to and lat.DateFrom>@from;	
		
					select top 1  * into #transactionTable1 from #temp2 where ranking=1	
					select @count=count(distinct #transactionTable1.EmployeeID) from #transactionTable1;		
																
					select @total= sum(lat.balance) from #transactionTable1 lat;	
														
					select e.WeekMode, 			
						e.total_workhour*t.LeavePerYear/(e.WeekMode*@defaultWorkHour) as _total,			
						t.LeaveTypeID into #t1 
					from #employeeTemp1 e 
					inner join #transactionTable1 t on e.id= t.EmployeeID
										
					set @A= (select sum(_tempResult)/@count from
					(
						select #t1.WeekMode, sum(#t1._total) as _tempResult 
						from #t1 group by #t1.WeekMode) as result
					);

					insert into @result values(@to,isnull(@total/@count,0.0), @groupByValue,isnull(@A*@defaultWorkHourPerDay,0.0));
					if (OBJECT_ID('tempdb..#employeeTemp1') is not null)				
						drop table #employeeTemp1	
					if (OBJECT_ID('tempdb..#temp2') is not null)			
						drop table #temp2	
					if (OBJECT_ID('tempdb..#t1') is not null)			
						drop table #t1	
					if (OBJECT_ID('tempdb..#transactionTable1') is not null)			
						drop table #transactionTable1						
					set @counter=@counter-1;								
				end		
				set @round= @round-1;
				set @counter=(select count(*) from #temp1);		
			end
			select * from @result
			if (OBJECT_ID('tempdb..#groupByTable') is not null)			
				drop table #groupByTable	
		end

		if (@groupBy = 'posorgunit3') begin
		set @round= (select count(distinct p.orgunit3) from Position p inner join EmployeePosition ep on p.id= ep.positionid
		where ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
			AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable)));
		select distinct ISNULL(p.orgunit3,'') as orgunit3, DENSE_RANK() over(order by isnull(p.orgunit3,'') desc) as id into #groupByTable1 
		from Position p inner join EmployeePosition ep on p.id= ep.positionid
		where ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable));			
		--select * from #groupByTable1;
			while (@round>=1) 
			begin				
				set @groupByValue= (select g.orgunit3 from #groupByTable1 g where g.id=@round);			
				while (@counter >=1) 
				begin 					
					set @to = (select dateto from #temp1 where #temp1.id=@counter);
					if (@counter>1)	
						set @from = (select dateto from #temp1 where #temp1.id=@counter-1) ;						
					if (@counter=1)
						set @from = 0 ;
														
					select e.id, isnull(e.location,'')as location, e.type, e.status, isnull(p.orgunit2,'') as orgunit2, isnull(p.orgunit3,'') as orgunit3, 			
						case when dbo.fnGetSumWorkHourByDay (e.id, @to)/ewh.WeekMode>@defaultWorkHour then @defaultWorkHour else dbo.fnGetSumWorkHourByDay (e.id, @to) end as total_workhour, 
						ewh.WeekMode as WeekMode into #employeeTemp2 
					from Employee e
						inner join EmployeePositionHistory ep on ep.employeeid= e.id
						inner join Position p on p.id= ep.positionid		
						inner join EmployeeWorkHoursHeader ewh on ewh.EmployeeID= e.id
						inner join EmployeeWorkHours ew on ewh.ID= ew.EmployeeWorkHoursHeaderID
					where 			
						@to between ewh.DateFrom and isnull(ewh.DateTo, getdate())
						and @to between ep.startdate and ISNULL(ep.enddate, GETDATE())
						and ewh.ID= dbo.fnGetWorkHourHeaderIDByDay (e.id, @to)
						and ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
						AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
						AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
						AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable))
						AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @idLocationTable))
						and ep.primaryposition='Y' 
						and ep.vacant='N'
						and e.IsPlaceholder!=1				
						and p.orgunit3=@groupByValue
					group by e.id, e.location, e.type, e.status, p.orgunit2, p.orgunit3, e.title, ewh.WeekMode
					;	
												
					select lat.EmployeeID, lt.ReportDescription, lat.DateFrom, lat.LeaveTypeID,lat.Balance, lt.LeavePerYear,
						RANK() over(partition by lat.EmployeeID, lat.leavetypeid order by lat.id desc) as ranking
					into #temp3
					from LeaveAccrualTransactions lat 
						inner join LeaveType lt on lat.LeaveTypeID= lt.ID	
						inner join #employeeTemp2 e on lat.EmployeeID=e.id		
					where 		
						lt.Code= @leavetype
						and lat.DateFrom<=@to and lat.DateFrom>@from;	
		
					select top 1  * into #transactionTable2 from #temp3 where ranking=1
					select @count=count(distinct #transactionTable2.EmployeeID) from #transactionTable2;			
				
					select @total= sum(lat.balance) from #transactionTable2 lat;
													
					select e.WeekMode, 			
						e.total_workhour*t.LeavePerYear/(e.WeekMode*@defaultWorkHour) as _total,			
						t.LeaveTypeID into #t2 
					from #employeeTemp2 e 
					inner join #transactionTable2 t on e.id= t.EmployeeID
										
					set @A= (select sum(_tempResult)/@count from
					(
						select #t2.WeekMode, sum(#t2._total) as _tempResult 
						from #t2 group by #t2.WeekMode) as result);
					insert into @result values(@to,isnull(@total/@count,0.0), @groupByValue,isnull(@A*@defaultWorkHourPerDay,0.0));

					if (OBJECT_ID('tempdb..#employeeTemp2') is not null)				
						drop table #employeeTemp2	
					if (OBJECT_ID('tempdb..#temp3') is not null)			
						drop table #temp3
					if (OBJECT_ID('tempdb..#t2') is not null)			
						drop table #t2
					if (OBJECT_ID('tempdb..#transactionTable2') is not null)			
						drop table #transactionTable2	
					set @counter=@counter-1;								
				end		
				set @round= @round-1;
				set @counter=(select count(*) from #temp1);		
			end
			select * from @result
			if (OBJECT_ID('tempdb..#groupByTable1') is not null)			
				drop table #groupByTable1	
		end
		if (@groupBy = 'location') begin
		set @round= (select count(distinct p.location) from Employee p inner join EmployeePosition ep on p.id= ep.positionid
		WHERE ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR isnull(p.location,'(Blank)') IN (SELECT * FROM @idLocationTable))
		and ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR p.type IN (SELECT * FROM @employeeTypeTable))	
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR p.status IN (SELECT * FROM @employeeStatusTable)));
		select distinct isnull(p.location,'') as location, DENSE_RANK() over(order by isnull(p.location,'') desc) as id into #groupByTable2 
		from Employee p inner join EmployeePosition ep on p.id= ep.positionid
		where ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR isnull(p.location,'(Blank)') IN (SELECT * FROM @idLocationTable))
		and ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR p.type IN (SELECT * FROM @employeeTypeTable))	
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR p.status IN (SELECT * FROM @employeeStatusTable))	
		--select * from #groupByTable2;

			while (@round>=1) 
			begin				
				set @groupByValue= (select g.location from #groupByTable2 g where g.id=@round);		
				print @round;			
				while (@counter >=1) 
				begin 
					print @groupByValue;				
					set @to = (select dateto from #temp1 where #temp1.id=@counter);
					if (@counter>1)	
						set @from = (select dateto from #temp1 where #temp1.id=@counter-1) ;						
					if (@counter=1)
						set @from = 0 ;
														
					select e.id, isnull(e.location,'')as location, e.type, e.status, isnull(p.orgunit2,'') as orgunit2, isnull(p.orgunit3,'') as orgunit3, 			
						case when dbo.fnGetSumWorkHourByDay (e.id, @to)/ewh.WeekMode>@defaultWorkHour then @defaultWorkHour else dbo.fnGetSumWorkHourByDay (e.id, @to) end as total_workhour, 
						ewh.WeekMode as WeekMode into #employeeTemp3 
					from Employee e
						inner join EmployeePositionHistory ep on ep.employeeid= e.id
						inner join Position p on p.id= ep.positionid		
						inner join EmployeeWorkHoursHeader ewh on ewh.EmployeeID= e.id
						inner join EmployeeWorkHours ew on ewh.ID= ew.EmployeeWorkHoursHeaderID
					where 			
						@to between ewh.DateFrom and isnull(ewh.DateTo, getdate())
						and @to between ep.startdate and ISNULL(ep.enddate, GETDATE())
						and ewh.ID= dbo.fnGetWorkHourHeaderIDByDay (e.id, @to)
						and ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
						AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
						AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
						AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable))
						AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @idLocationTable))
						and ep.primaryposition='Y' 
						and ep.vacant='N'
						and e.IsPlaceholder!=1				
						and e.location=@groupByValue
					group by e.id, e.location, e.type, e.status, p.orgunit2, p.orgunit3, e.title, ewh.WeekMode
					;

					--select * from #employeeTemp3;
					--select @count=count(*) from #employeeTemp3;
					select lat.EmployeeID, lt.ReportDescription, lat.DateFrom, lat.LeaveTypeID,lat.Balance, lt.LeavePerYear,
						RANK() over(partition by lat.EmployeeID, lat.leavetypeid order by lat.id desc) as ranking
					into #temp4
					from LeaveAccrualTransactions lat 
						inner join LeaveType lt on lat.LeaveTypeID= lt.ID	
						inner join #employeeTemp3 e on lat.EmployeeID=e.id		
					where 		
						lt.Code= @leavetype
						and lat.DateFrom<=@to and lat.DateFrom>@from;	
		
					select top 1 * into #transactionTable3 from #temp4 where ranking=1		
					select @count=count(distinct #transactionTable3.EmployeeID) from #transactionTable3;	
					--select * from #transactionTable3;	
								
					select @total= sum(lat.balance) from #transactionTable3 lat;	
					set @leaveperyear= (select top 1 lt.LeavePerYear from LeaveType lt where lt.Code=@leavetype)
					set @total_workhour = (select sum(e.total_workhour/e.WeekMode) from #employeeTemp3 e);			

					select e.WeekMode, 			
						e.total_workhour*t.LeavePerYear/(e.WeekMode*@defaultWorkHour) as _total,			
						t.LeaveTypeID into #t3 
					from #employeeTemp3 e 
					inner join #transactionTable3 t on e.id= t.EmployeeID
					
					--select * from #t3
					set @A= (select sum(_tempResult)/@count from
					(
						select #t3.WeekMode, sum(#t3._total) as _tempResult 
						from #t3 group by #t3.WeekMode) as result);
					insert into @result values(@to,isnull(@total/@count,0.0), @groupByValue,isnull(@A*@defaultWorkHourPerDay,0.0));
					if (OBJECT_ID('tempdb..#employeeTemp3') is not null)				
						drop table #employeeTemp3	
					if (OBJECT_ID('tempdb..#temp4') is not null)			
						drop table #temp4
					if (OBJECT_ID('tempdb..#t3') is not null)			
						drop table #t3
					if (OBJECT_ID('tempdb..#transactionTable3') is not null)			
						drop table #transactionTable3	
					set @counter=@counter-1;								
				end		
				set @round= @round-1;
				set @counter=(select count(*) from #temp1);		
			end
			select * from @result
			if (OBJECT_ID('tempdb..#groupByTable') is not null)			
				drop table #groupByTable2	
		end				
	end
	if (OBJECT_ID('tempdb..#employeeTable') is not null)			
		drop table #employeeTable			
	if (OBJECT_ID('tempdb..#temp1') is not null)			
		drop table #temp1			
END
