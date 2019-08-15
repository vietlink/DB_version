/****** Object:  Procedure [dbo].[uspCreateDeletedHistoryItem]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateDeletedHistoryItem](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- remove all future ones, future statuses dont apply once employee is deleted
    DELETE FROM EmployeeStatusHistory WHERE StartDate > GETDATE();

	DECLARE @deletedStatusId int = 0;
	SELECT @deletedStatusId = id FROM [Status] WHERE code = 'd';

	DECLARE @currentId int = 0;
	SELECT TOP 1 @currentId = id FROM EmployeeStatusHistory WHERE EmployeeID = @empId ORDER BY StartDate DESC;
	UPDATE EmployeeStatusHistory SET EndDate = dateadd(day,datediff(day,1,GETDATE()),0), StatusID = @deletedStatusId WHERE id = @currentId;
	--INSERT INTO EmployeeStatusHistory(EmployeeID, StatusID, StartDate, EndDate, LastUpdatedBy, LastUpdatedDate)
	--	VALUES(@empId, @deletedStatusId, GETDATE(), NULL, 'system', GETDATE());
END

