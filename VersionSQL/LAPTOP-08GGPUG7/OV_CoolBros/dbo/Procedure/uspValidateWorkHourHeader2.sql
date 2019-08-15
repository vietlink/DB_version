/****** Object:  Procedure [dbo].[uspValidateWorkHourHeader2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
creaTE PROCEDURE [dbo].[uspValidateWorkHourHeader2](@empId int, @dateFrom datetime, @dateTo datetime, @headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @startDate datetime = null;

	SELECT 
		@startDate = DateFrom 
	FROM 
		EmployeeWorkHoursHeader 
	WHERE		
		Employeeid = @empId AND id <> @headerId
		AND
		((DateFrom BETWEEN @dateFrom AND isnull(@dateTo, '12-31-9999'))
		OR
		DateTo BETWEEN @dateFrom AND isnull(@dateTo, '12-31-9999')
		OR
		(DateTo = @dateTo OR DateFrom = @dateFrom))
	
	--SELECT @startDate = DateFrom FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND
	--	DateFrom >= @dateFrom AND id <> @headerId
	
	--IF @startDate IS NULL BEGIN
	--	SELECT @startDate = DateFrom FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND
	--		DateFrom < @dateTo AND DateTo > @dateTo AND id <> @headerId
	--END

	--IF @startDate IS NULL BEGIN
	--	SELECT @startDate = DateFrom FROM EmployeeWorkHoursHeader WHERE EmployeeID = @empId AND
	--		DateFrom = @dateFrom AND id <> @headerId
	--END

	SELECT @startDate as DateFrom;
    
END

