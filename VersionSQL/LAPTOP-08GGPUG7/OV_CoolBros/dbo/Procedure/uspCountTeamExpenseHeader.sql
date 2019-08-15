/****** Object:  Procedure [dbo].[uspCountTeamExpenseHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspCountTeamExpenseHeader] 
	-- Add the parameters for the stored procedure here
	@managerID int, @approverPosID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
	SELECT 	
	es.Description AS Status,
	es.Code AS StatusCode,
	count(ech.id) as _count
	
	FROM ExpenseClaimHeader ech
	INNER JOIN ExpenseStatus es ON ech.ExpenseClaimStatusID = es.ID	
	INNER JOIN Employee e ON ech.CreatedForUserID = e.id
	--INNER JOIN Employee e ON u.accountname = e.accountname
	
	WHERE 
	
	((@approverPosID!=0) OR (@approverPosID=0 AND ( e.id IN (SELECT * FROM dbo.fnGetEmployeeIDByManagerID(@managerID)))))	
	AND (es.Code='S' OR (es.Code='A' AND ech.PayCycleID is null))
	GROUP BY es.Description, es.Code	

END

