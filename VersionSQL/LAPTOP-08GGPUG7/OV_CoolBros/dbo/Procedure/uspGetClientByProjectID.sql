/****** Object:  Procedure [dbo].[uspGetClientByProjectID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetClientByProjectID] 
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

		SELECT c.ID as id,
		c.Description as client,
		p.Description as projectName,
		p.Code as projectCode,
		p.IsActive as status
		FROM Projects p
		INNER JOIN Clients c on p.ClientID=c.ID
		WHERE p.ID=@id		
	
END

