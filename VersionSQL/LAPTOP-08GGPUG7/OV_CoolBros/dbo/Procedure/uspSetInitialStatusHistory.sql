/****** Object:  Procedure [dbo].[uspSetInitialStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetInitialStatusHistory](@empId int, @lastUpdatedBy varchar(255), @lastUpdatedDate datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @status VARCHAR(50);
	DECLARE @statusId int;
	DECLARE @commence DATETIME;

	SELECT @status = [status], @commence = commencement FROM Employee WHERE id = @empId;
	SELECT @statusId = id FROM [status] WHERE [Description] = @status;

	DECLARE @historyCount int = 0;

	SELECT @historyCount = ISNULL(COUNT(*), 0) FROM EmployeeStatusHistory WHERE EmployeeID = @empId;

	IF @historyCount < 1 AND @statusId > 0 BEGIN
		INSERT INTO EmployeeStatusHistory(EmployeeID, StatusID, StartDate, LastUpdatedBy, LastUpdatedDate)
			VALUES(@empId, @statusId, ISNULL(@commence, GETDATE()), @lastUpdatedBy, @lastUpdatedDate);
	END
END


