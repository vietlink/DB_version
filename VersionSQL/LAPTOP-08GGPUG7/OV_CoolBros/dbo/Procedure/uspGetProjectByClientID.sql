/****** Object:  Procedure [dbo].[uspGetProjectByClientID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetProjectByClientID] 
	-- Add the parameters for the stored procedure here
	@id int, @active int, @status int, @clientStatus int, @filter varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@id=0) BEGIN
		SELECT p.ID as id,
		 c.Description as client,
		p.Description as projectName,
		p.Code as projectCode,
		p.IsActive as status
		FROM Projects p
		INNER JOIN Clients c on p.ClientID=c.ID
		where
		((c.Description LIKE '%'+@filter +'%') OR (p.Description LIKE '%'+@filter +'%') OR (p.Code LIKE '%'+@filter +'%'))
		AND ((c.IsDeleted = @clientStatus AND @clientStatus<>2) OR (@clientStatus=2))
		AND ((IsActive = @active AND @active <> 2) OR (@active = 2))
		AND p.IsDeleted = @status 
		
	END ELSE BEGIN
		SELECT p.ID as id,
		c.Description as client,
		p.Description as projectName,
		p.Code as projectCode,
		p.IsActive as status
		FROM Projects p
		INNER JOIN Clients c on p.ClientID=c.ID
		WHERE ClientID=@id
		--AND c.IsDeleted = @clientStatus
		AND ((c.Description LIKE '%'+@filter +'%') OR (p.Description LIKE '%'+@filter +'%') OR (p.Code LIKE '%'+@filter +'%'))
		AND ((c.IsDeleted = @clientStatus AND @clientStatus<>2) OR (@clientStatus=2))
		AND ((IsActive = @active AND @active <> 2)OR (@active = 2))
		AND p.IsDeleted = @status 
	END
END

