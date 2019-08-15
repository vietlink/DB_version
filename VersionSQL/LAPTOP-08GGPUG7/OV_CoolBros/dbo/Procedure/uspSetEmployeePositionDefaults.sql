/****** Object:  Procedure [dbo].[uspSetEmployeePositionDefaults]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetEmployeePositionDefaults]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @posId int = 0;
	DECLARE @empId int = 0;
	SELECT top 1 @posId = id from position where IsUnassigned = 1;
	DECLARE empScan CURSOR FOR
	select distinct id from employee where id not in (select employeeid from EmployeePosition) and identifier <> 'vacant'
	OPEN empScan;
	FETCH NEXT FROM empScan into @empId;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS(SELECT * FROM EmployeePosition WHERE positionid = @posid AND employeeid = @empid) BEGIN
			INSERT INTO EmployeePosition(employeeid, positionid, primaryposition, Managerial, ExclFromSubordCount) 
				VALUES(@empid, @posid, 'Y', 'N', 'N')
		END
		FETCH NEXT FROM empScan into @empId;
	END
	CLOSE empScan;
	DEALLOCATE empScan;
END

