/****** Object:  Procedure [dbo].[uspCreateUnDeletedHistoryItem]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateUnDeletedHistoryItem](@empId int, @groupMode bit = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @empIsDeleted bit = 0;
	SELECT @empIsDeleted = IsDeleted, @groupMode = isplaceholder FROM Employee WHERE id = @empId;

	IF @empIsDeleted = 1 BEGIN
		-- remove all future ones, future statuses dont apply once employee is deleted
		DELETE FROM EmployeeStatusHistory WHERE StartDate > GETDATE();

		DECLARE @undeletedStatusId int = 0;
		SELECT @undeletedStatusId = id FROM [Status] WHERE code = 'a'; -- use active status
	
		DECLARE @deletedStatusId int = 0;
		SELECT @deletedStatusId = id FROM [Status] WHERE code = 'd';

	--	DELETE FROM EmployeeStatusHistory WHERE id = 
	--	(SELECT TOP 1 ID FROM EmployeeStatusHistory WHERE EmployeeID = @empId AND statusid = @deletedStatusId ORDER BY StartDate DESC)

		DECLARE @currentId int = 0;
		SELECT TOP 1 @currentId = id FROM EmployeeStatusHistory WHERE EmployeeID = @empId ORDER BY StartDate DESC;
		UPDATE EmployeeStatusHistory SET EndDate = null, StatusID = @undeletedStatusId WHERE id = @currentId;
		--INSERT INTO EmployeeStatusHistory(EmployeeID, StatusID, StartDate, EndDate, LastUpdatedBy, LastUpdatedDate)
		--	VALUES(@empId, @undeletedStatusId, GETDATE(), NULL, 'system', GETDATE());

		IF @groupMode = 1 BEGIN
			UPDATE Employee SET IsDeleted = 0 WHERE id = @empid;
			DECLARE @id varchar(100);
			SELECT @id = identifier FROM Employee WHERE id = @empid;
			DECLARE @posId int = 0;
			SELECT @posId = id FROM Position WHERE Identifier = @id;
			UPDATE Position SET IsDeleted = 0 WHERE id = @posId;
			UPDATE EmployeePosition SET IsDeleted = 0 WHERE EmployeeID = @empID and PositionID = @posId
			UPDATE EmployeePositionInfo SET IsVisible = 1 WHERE EmployeeID = @empID and PositionID = @posId
		END

	END
END


