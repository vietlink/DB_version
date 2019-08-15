/****** Object:  Procedure [dbo].[uspGetEmployeeByStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeByStatus] 
	-- Add the parameters for the stored procedure here
	@employeeStatusFilter varchar(max) 
	 AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @employeeStatusTable table(employeeStatus varchar(max));
	IF CHARINDEX(',', @employeeStatusFilter, 0) > 0 BEGIN
		INSERT INTO @employeeStatusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@employeeStatusFilter, ',');	
    END
    ELSE IF LEN(@employeeStatusFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeStatusTable(employeeStatus) VALUES(@employeeStatusFilter);	
    END		
    -- Insert statements for procedure here
	SELECT e.id AS employeeid,
	e.displayname
	FROM Employee e
	--INNER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.isDeleted=0
	WHERE ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))			
	AND e.IsPlaceholder!=1	
	AND e.displayname!='Vacant'
	AND e.[status] <> 'Deleted'
	--AND dbo.fnCheckPermissionAttCode('personnotereport', 2, 19, e.id, ep.positionid, 1)=1
	ORDER BY e.displayname
END

