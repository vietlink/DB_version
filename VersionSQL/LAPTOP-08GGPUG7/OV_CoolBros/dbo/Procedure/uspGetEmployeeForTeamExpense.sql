/****** Object:  Procedure [dbo].[uspGetEmployeeForTeamExpense]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeForTeamExpense] 
	-- Add the parameters for the stored procedure here
	@approverID int, @statusList varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @statusTable TABLE (code varchar(5));
	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @statusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusList, ',');	
    END
    ELSE IF LEN(@statusList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @statusTable(code) VALUES(@statusList ) ;	
    END
    -- Insert statements for procedure here
	SELECT *
	FROM Employee e
	--INNER JOIN [User] u ON e.displayname = u.displayname
	INNER JOIN ExpenseClaimHeader ech ON e.id= ech.CreatedForUserID
	INNER JOIN ExpenseStatus es ON ech.ExpenseClaimStatusID= es.ID
	WHERE (es.Code='S' OR (es.Code='A' AND ech.PayCycleID is null))
	AND ((@approverID=0) OR ((@approverID!=0) 
	AND ( e.id IN (SELECT * FROM dbo.fnGetEmployeeIDByManagerID(@approverID)))
	AND ((SELECT COUNT(*) FROM @statusTable) = 0 OR es.Code IN (SELECT * FROM @statusTable))))
END

