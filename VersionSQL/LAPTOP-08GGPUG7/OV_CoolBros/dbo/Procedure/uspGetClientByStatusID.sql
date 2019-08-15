/****** Object:  Procedure [dbo].[uspGetClientByStatusID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetClientByStatusID] 
	-- Add the parameters for the stored procedure here
	@status int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@status<>-1) BEGIN
		SELECT c.*
		FROM Clients c
		WHERE c.IsDeleted=@status
		ORDER BY c.Description
	END ELSE BEGIN
		SELECT * 
		FROM Clients c
		ORDER BY c.Description
	END
END

