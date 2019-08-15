/****** Object:  Procedure [dbo].[uspOvertimeReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspOvertimeReport] 
	-- Add the parameters for the stored procedure here
	--@payCycleGroup int, @fromDate datetime, @toDate datetime, 
	@chkIncludeNotApprove varchar(1), @paycycleGroupID varchar(3), @personID varchar(3),
	 @from varchar(max), @to varchar(max), 
	 @divisionFilter varchar(max), @departmentFilter varchar(max), 
	@locationFilter varchar(max), @statusFilter varchar(max), @typeFilter varchar(max), @sortBy varchar(max), @groupBy varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @col_list VARCHAR(max)=(SELECT STUFF((SELECT ',' + '['+[Description]+']'
							FROM [LoadingRate]
							WHERE IsDeleted=0
							ORDER BY [Description]
							FOR XML PATH('')) ,1,1,''))

DECLARE @col_list_sum VARCHAR(max)=(SELECT STUFF((SELECT ',' + 'sum(['+[Description]+']) as '+ '['+[Description]+']'
							FROM [LoadingRate]
							WHERE IsDeleted=0
							ORDER BY [Description]
							FOR XML PATH('')) ,1,1,''))
--select @col_list
DECLARE @sql nvarchar(max)=
'DECLARE @chkIncludeNotApprove varchar(1)='''+@chkIncludeNotApprove+''';
DECLARE @paycycleGroupID varchar(9)='''+@paycycleGroupID+''';
DECLARE @personID varchar(9)='''+@personID+''';
DECLARE @from DATETIME='''+@from+''';
DECLARE @to DATETIME= '''+@to+''';
DECLARE @divisionFilter varchar(max)='''+@divisionFilter+''';
DECLARE @departmentFilter varchar(max)='''+@departmentFilter+''';
DECLARE @locationFilter varchar(max)='''+@locationFilter+''';
DECLARE @typeFilter varchar(max)='''+@typeFilter+''';
DECLARE @statusFilter varchar(max)='''+@statusFilter+''';
DECLARE @groupBy varchar(max)='''+@groupBy+''';
DECLARE @sortBy varchar(max)='''+@sortBy+''';
DECLARE @idDepartmentTable TABLE(idDepartment varchar(max));
DECLARE @idDivisionTable TABLE(idDivision varchar(max));
DECLARE @idLocationTable TABLE(idLocation varchar(max));
DECLARE @employeeTypeTable TABLE(employeeType varchar(max));
DECLARE @employeeStatusTable TABLE(employeeStatus varchar(max));	
IF CHARINDEX('','',@divisionFilter, 0) > 0 BEGIN
		INSERT INTO @idDivisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionFilter, '','');	
    END
    ELSE IF LEN(@divisionFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDivisionTable(idDivision) VALUES(@divisionFilter);	
    END
	
	IF CHARINDEX('','',@departmentFilter, 0) > 0 BEGIN
		INSERT INTO @idDepartmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentFilter, '','');	
    END
    ELSE IF LEN(@departmentFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDepartmentTable(idDepartment) VALUES(@departmentFilter);	
    END
	
	IF CHARINDEX('';'', @locationFilter, 0) > 0 BEGIN
		INSERT INTO @idLocationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationFilter, '';'');	
    END
    ELSE IF LEN(@locationFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idLocationTable(idLocation) VALUES(@locationFilter);	
    END

	IF CHARINDEX('','',@typeFilter, 0) > 0 BEGIN
		INSERT INTO @employeeTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@typeFilter, '','');	
    END
    ELSE IF LEN(@typeFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeTypeTable(employeeType) VALUES(@typeFilter);	
    END	

	IF CHARINDEX('','',@statusFilter, 0) > 0 BEGIN
		INSERT INTO @employeeStatusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusFilter, '','');	
    END
    ELSE IF LEN(@statusFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeStatusTable(employeeStatus) VALUES(@statusFilter);	
    END		

SELECT * FROM (	
SELECT EmployeeID, name, surname, title, posorgunit2, posorgunit3, PayrollCycleDesc, PayrollCycleFromDate, PayrollCycleToDate, location, type, SalaryBase
, sum(NormalRate) as NormalRate, sum(ToilRate) as ToilRate, NormalLoadingRate
, '+@col_list_sum+'
FROM
(
	SELECT *
	FROM (
			SELECT
			  TH.EmployeeID
			  ,E.displayname as name
			  ,E.surname
			  ,case when isnull(P.[description],'''')='''' then ''(Blank)'' else P.[description] end as title
			  ,case when isnull(P.orgunit2,'''')='''' then ''(Blank)'' else P.orgunit2 end as posorgunit2
			  ,case when isnull(P.orgunit3,'''')='''' then ''(Blank)'' else P.orgunit3 end as posorgunit3
			  ,case when isnull(E.location,'''')='''' then ''(Blank)'' else E.location end as location
			  ,isnull(E.type,''(Blank)'') as  type
			  ,EWHH.SalaryBase
			  ,TRA.NormalRate as NormalRate
			  ,TRA.ToilRate as ToilRate
			  ,LR.Description
			  ,TRAI.Balance as Balance
			  ,PCG.ID as PayrollCycleGroupID
			  ,PCG.Description as PayrollCycleGroupDesc
			  ,PC.ID as PayrollCycleID
			  ,PC.Description as PayrollCycleDesc
			  ,PC.FromDate as PayrollCycleFromDate
			  ,PC.ToDate as PayrollCycleToDate
			  ,lr1.Value as NormalLoadingRate
			FROM 
			  [TimesheetHeader] TH
			  LEFT JOIN [TimesheetRateAdjustment] TRA ON TH.ID = TRA.TimesheetHeaderID and TRA.IsFinalisedHours = 1
			  LEFT JOIN [TimesheetRateAdjustmentItem] TRAI ON TRA.ID = TRAI.TimesheetRateAdjustmentID
			  LEFT JOIN [LoadingRate] LR ON TRAI.RateID = LR.ID
			  INNER JOIN [PayrollCycle] PC ON TH.PayrollCycleID = PC.ID
			  INNER JOIN [PayrollCycleGroups] PCG ON PC.PayrollCycleGroupID = PCG.ID
			  INNER JOIN [EmployeeWorkHoursHeader] EWHH ON EWHH.ID = dbo.fnGetWorkHourHeaderIDByDay(TH.EmployeeID,PC.FromDate)
			  INNER JOIN [Employee] E ON TH.EmployeeID = E.ID
			  INNER JOIN [EmployeePosition] EP ON E.ID = EP.EmployeeID and EP.IsDeleted = 0 and EP.primaryposition = ''Y''
			  INNER JOIN [Position] P ON EP.PositionID = P.ID
			  INNER JOIN [TimesheetStatus] TS ON TH.TimesheetStatusID = TS.ID, LoadingRate lr1

			WHERE 
			  TRA.NormalRate is not null 
			  and ((TS.Code = ''A'' and cast(@chkIncludeNotApprove as int)=0) OR ((TS.Code=''A'' OR TS.Code=''S'') AND cast(@chkIncludeNotApprove as int)=1))
			  AND ((E.id = cast(@personID as int) AND cast(@personID as int)!=0) OR (cast(@personID as int)=0))
			  AND PCG.ID=cast(@paycycleGroupID as int)
			  AND (PC.FromDate>=@from AND PC.ToDate<=@to)
			  AND lr1.IsNormalRate=1
			  AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR case when isnull(P.orgunit3,'''')='''' then ''(Blank)'' else P.orgunit3 end IN (SELECT * FROM @idDepartmentTable))
			  AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR case when isnull(P.orgunit2,'''')='''' then ''(Blank)'' else P.orgunit2 end IN (SELECT * FROM @idDivisionTable))
			  AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR case when isnull(E.location,'''')='''' then ''(Blank)'' else E.location end IN (SELECT * FROM @idLocationTable))
			  AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR E.status IN (SELECT * FROM @employeeStatusTable))
			  AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(E.type,''(Blank)'') IN (SELECT * FROM @employeeTypeTable))
			
	) as s
	PIVOT
	(
		SUM(Balance)
		FOR [Description] IN ('+@col_list+')
	)AS pvt
) AS Q1
GROUP BY EmployeeID, name,surname, title, posorgunit2, posorgunit3,PayrollCycleDesc,PayrollCycleFromDate, PayrollCycleToDate, location, type, SalaryBase, NormalLoadingRate) As Result
ORDER BY		
	CASE WHEN @groupBy = ''posorgunit2'' THEN Result.posorgunit2 END,		
	CASE WHEN @groupBy = ''posorgunit3'' THEN Result.posorgunit3 END,
	CASE WHEN @groupBy = ''location'' THEN Result.location END,		
	CASE WHEN @groupBy = ''title'' THEN Result.title END,		
	CASE WHEN @groupBy= ''name'' THEN Result.name END,
	--CASE WHEN @groupBy = ''PayrollCycleDesc'' THEN Result.PayrollCycleDesc END,	
	CASE WHEN @groupBy = ''PayrollCycleDesc'' THEN Result.PayrollCycleFromDate END,		
	CASE WHEN @sortBy = ''title'' THEN Result.title END,						
	CASE WHEN @sortBy = ''surname'' THEN Result.surname END,	
	CASE WHEN @sortBy = ''PayrollCycleDesc'' THEN Result.PayrollCycleFromDate END,	
	CASE WHEN @sortBy= ''name'' THEN Result.name END
'
PRINT @sql
EXEC sp_executesql @sql
 

END

