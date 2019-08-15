/****** Object:  Procedure [dbo].[uspGetEmployeeProjectByFilter]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeProjectByFilter] 
	-- Add the parameters for the stored procedure here	
	@clientID int, @empID int, @projectID int, @status int, @filter varchar(max), @header varchar(max), @order int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	c.description AS client,
	p.description AS project,
	e.displayname AS name,
	cc.description AS centre,
	epr.isDeleted AS status
	FROM 
	EmployeeProject epr
	INNER JOIN Employee e ON e.ID= epr.EmployeeID
	INNER JOIN Projects p ON p.id= epr.ProjectID
	INNER JOIN CostCentres cc ON cc.id= epr.PayCostCentreID
	INNER JOIN Clients c ON p.clientid= c.id	
	WHERE ((c.id =@clientID) OR(@clientID=0 AND c.IsDeleted=0) OR (@clientID=-1 AND c.IsDeleted=1))
	AND ((e.id= @empID)  OR (@empID=0))
	AND ((p.id= @projectID) OR (@projectID=0 AND p.IsActive=1) OR (@projectID=-1 AND p.IsActive=0))
	AND ((epr.isDeleted = @status AND @status<>2) OR (@status=2))
	AND ((c.Description LIKE '%'+@filter+'%') OR (p.Description LIKE '%'+@filter+'%') OR (e.displayname LIKE '%'+@filter+'%') OR (cc.description LIKE '%'+@filter+'%'))
	
	ORDER BY
		CASE WHEN ((@order=1) AND (@header='thClient_main')) THEN c.Description END ASC,
		CASE WHEN ((@order=1) AND (@header='thClient_main')) THEN p.Description END ASC,
		CASE WHEN ((@order=1) AND (@header='thClient_main')) THEN e.displayname END ASC,

		CASE WHEN ((@order=-1) AND (@header='thClient_main')) THEN c.Description END DESC,
		CASE WHEN ((@order=-1) AND (@header='thClient_main')) THEN p.Description END DESC,
		CASE WHEN ((@order=-1) AND (@header='thClient_main')) THEN e.displayname END DESC,

		CASE WHEN ((@order=1) AND (@header='thProject_main')) THEN p.Description END ASC,
		CASE WHEN ((@order=1) AND (@header='thProject_main')) THEN c.Description END ASC,
		CASE WHEN ((@order=1) AND (@header='thProject_main')) THEN e.displayname END ASC,
		CASE WHEN ((@order=-1) AND (@header='thProject_main')) THEN p.Description END DESC,
		CASE WHEN ((@order=-1) AND (@header='thProject_main')) THEN c.Description END DESC,
		CASE WHEN ((@order=-1) AND (@header='thProject_main')) THEN e.displayname END DESC,

		CASE WHEN ((@order=1) AND (@header='thName_main')) THEN e.displayname END ASC,
		CASE WHEN ((@order=1) AND (@header='thName_main')) THEN c.Description END ASC,
		CASE WHEN ((@order=1) AND (@header='thName_main')) THEN p.Description END ASC,
		CASE WHEN ((@order=-1) AND (@header='thName_main')) THEN e.displayname END DESC,
		CASE WHEN ((@order=-1) AND (@header='thName_main')) THEN c.Description END DESC,
		CASE WHEN ((@order=-1) AND (@header='thName_main')) THEN p.Description END DESC,

		CASE WHEN ((@order=1) AND (@header='thCentre_main')) THEN cc.Description END ASC,
		CASE WHEN ((@order=-1) AND (@header='thCentre_main')) THEN cc.Description END DESC,

		CASE WHEN ((@order=1) AND (@header='thStatus_main')) THEN epr.isDeleted END ASC,
		CASE WHEN ((@order=-1) AND (@header='thStatus_main')) THEN epr.isDeleted END DESC,
		CASE WHEN ((@order=0) AND (@header='')) THEN c.Description END, 
		CASE WHEN ((@order=0) AND (@header='')) THEN p.Description END 
END

