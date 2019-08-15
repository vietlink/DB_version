/****** Object:  Procedure [dbo].[uspGetProjectByStatusID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetProjectByStatusID] 
	-- Add the parameters for the stored procedure here
	@status int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@status<>2) BEGIN
		SELECT p.*, c.Description AS client
		FROM Projects p
		INNER JOIN Clients c ON p.ClientID= c.ID
		WHERE p.IsActive=@status
		ORDER BY c.Description, p.Description
	END ELSE BEGIN
		SELECT p.*, c.Description AS client 
		FROM Projects p
		INNER JOIN Clients c ON p.ClientID= c.ID
		ORDER BY c.Description, p.Description
	END
END

