/****** Object:  Procedure [dbo].[uspGetProjectByClient]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetProjectByClient] 
	-- Add the parameters for the stored procedure here
	@empid int, @clientid int, @active int, @status int, @filter varchar(max), @header varchar(max), @order int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM (	
		SELECT p.ID as id,
		epr.employeeid as empid,
		c.Description as client,
		p.Description as projectName,
		p.Code as projectCode,
		epr.isdeleted as status,
		cc.description as centre
		FROM Projects p
		INNER JOIN Employeeproject epr ON p.id= epr.projectid		
		INNER JOIN Clients c on p.ClientID=c.ID
		INNER JOIN CostCentres cc ON epr.PayCostCentreID= cc.id
		WHERE ((ClientID=@clientid) OR (@clientid=0))
		AND ((epr.employeeid= @empid) OR (@empid=0))
		AND ((IsActive = @active AND p.IsDeleted = @status AND @active <> 2)
		OR (@active = 2 AND p.IsDeleted = @status))
		AND ((c.Description LIKE '%'+@filter+'%') OR (p.Description LIKE '%'+@filter+'%') OR (cc.Description LIKE '%'+@filter+'%'))
	UNION
		SELECT p.ID as id,
		0 as empid,
		c.Description as client,
		p.Description as projectName,
		p.Code as projectCode,
		1 as status,
		cc.description as centre
		FROM Projects p
		--INNER JOIN Employeeproject epr ON p.id= epr.projectid		
		INNER JOIN Clients c on p.ClientID=c.ID
		INNER JOIN CostCentres cc ON p.PayCostCentreID= cc.id
		WHERE ((ClientID=@clientid) OR (@clientid=0))
		AND p.id NOT IN (SELECT ep.projectid FROM EmployeeProject ep WHERE ep.employeeid =@empid)
		AND ((IsActive = @active AND p.IsDeleted = @status AND @active <> 2)
		OR (@active = 2 AND p.IsDeleted = @status))
		AND ((c.Description LIKE '%'+@filter+'%') OR (p.Description LIKE '%'+@filter+'%') OR (cc.Description LIKE '%'+@filter+'%'))
		) AS Result
	ORDER BY 
		CASE WHEN ((@order=1) AND (@header='thClient_Project')) THEN Result.client END ASC,
		CASE WHEN ((@order=1) AND (@header='thClient_Project')) THEN Result.projectName END ASC,
		CASE WHEN ((@order=-1) AND (@header='thClient_Project')) THEN Result.client END DESC,
		CASE WHEN ((@order=-1) AND (@header='thClient_Project')) THEN Result.projectName END DESC,

		CASE WHEN ((@order=1) AND (@header='thProject_Project')) THEN Result.projectName END ASC,
		CASE WHEN ((@order=1) AND (@header='thProject_Project')) THEN Result.client END ASC,
		CASE WHEN ((@order=-1) AND (@header='thProject_Project')) THEN Result.projectName END DESC,
		CASE WHEN ((@order=-1) AND (@header='thProject_Project')) THEN Result.client END DESC,

		CASE WHEN ((@order=1) AND (@header='thCentre_Project')) THEN Result.centre END ASC,
		CASE WHEN ((@order=-1) AND (@header='thCentre_Project')) THEN Result.centre END DESC,		

		CASE WHEN ((@order=1) AND (@header='thStatus_Project')) THEN Result.status END ASC,
		CASE WHEN ((@order=-1) AND (@header='thStatus_Project')) THEN Result.status END DESC,

		CASE WHEN ((@order=0) AND (@header='')) THEN Result.client END,
		CASE WHEN ((@order=0) AND (@header='')) THEN Result.projectName END
	
END

