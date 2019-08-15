/****** Object:  Procedure [dbo].[uspCloseLastEmployeeStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCloseLastEmployeeStatusHistory](@employeeId int, @historyid int, @startDate datetime, @endDate datetime, @currentCode varchar(10) = '')
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @historyid = 0 BEGIN
		DECLARE @id int = 0;
		DECLARE @statusId int = 0;
		DECLARE @start datetime;

		SELECT TOP 1 @id = id, @statusId = StatusID, @start = StartDate FROM EmployeeStatusHistory WHERE EmployeeID = @employeeId ORDER BY StartDate DESC;

		DECLARE @code varchar(50);
		SELECT @code = code FROM [status] WHERE id = @statusId

		IF @currentCode = 't' BEGIN
			DECLARE @time varchar(10);
			SELECT @time = CONVERT(VARCHAR(8),@start,108);
			DECLARE @newDate datetime = CONVERT(DATETIME, CONVERT(varchar(20),@startDate, 111 ) + ' 00:00', 111)
			UPDATE EmployeeStatusHistory SET EndDate = @newDate WHERE id = @id;
		END ELSE BEGIN				
			UPDATE EmployeeStatusHistory SET EndDate = dateadd(dd, -1, @startDate) WHERE id = @id;
		END
	END
	ELSE BEGIN -- Edit mode, check next and prev
		DECLARE @prevRecordId int = 0;
		DECLARE @prevRecordStatusId int = 0;
		DECLARE @prevRecordStartDate datetime;

		DECLARE @nextRecordId int = 0;
		DECLARE @nextRecordStatusId int = 0;
		DECLARE @nextRecordStartDate datetime;

		DECLARE @currentStatusId int = 0;
		DECLARE @currentStatusCode varchar(10);

		SELECT @currentStatusId = [statusid] FROM EmployeeStatusHistory WHERE id = @historyid;
		SELECT @currentStatusCode = code FROM [status] WHERE id = @currentStatusId

		SELECT TOP 1 @prevRecordId = id, @prevRecordStatusId = statusid, @prevRecordStartDate = startdate FROM EmployeeStatusHistory 
			WHERE employeeid = @employeeid AND id < @historyid
			ORDER BY id desc

		SELECT TOP 1 @nextRecordId = id, @nextRecordStatusId = statusid, @nextRecordStartDate = startdate FROM EmployeeStatusHistory 
			WHERE employeeid = @employeeid AND id > @historyid
			ORDER BY id asc

		IF @nextRecordId > 0 AND @endDate IS NOT NULL BEGIN
			DECLARE @nextStatusCode varchar(10);
			SELECT @nextStatusCode = code FROM [status] WHERE id = @nextRecordStatusId;

			IF @nextStatusCode = 't' BEGIN
				DECLARE @nextTime varchar(10);
				SELECT @nextTime = CONVERT(VARCHAR(8),@nextRecordStartDate,108);
				DECLARE @nextNewDate datetime = CONVERT(DATETIME, CONVERT(varchar(20),@endDate, 111 ) + ' ' + @nextTime, 111);
				UPDATE EmployeeStatusHistory SET StartDate = @nextNewDate WHERE id = @nextRecordId;
			END ELSE BEGIN
				UPDATE EmployeeStatusHistory SET StartDate = dateadd(dd, 1, @endDate) WHERE id = @nextRecordId;
			END
		END

		IF @prevRecordId > 0 BEGIN
			DECLARE @prevStatusCode varchar(10);
			SELECT @prevStatusCode = code FROM [status] WHERE id = @prevRecordStatusId;

			IF @currentStatusCode = 't' BEGIN
				DECLARE @prevNewDate datetime = CONVERT(DATETIME, CONVERT(varchar(20),@startDate, 111 ) + ' 00:00', 111);
				UPDATE EmployeeStatusHistory SET EndDate = @prevNewDate WHERE id = @prevRecordId
			END ELSE BEGIN
				UPDATE EmployeeStatusHistory SET EndDate = dateadd(dd, -1, @startDate) WHERE id = @prevRecordId
			END
		END
	END
END

