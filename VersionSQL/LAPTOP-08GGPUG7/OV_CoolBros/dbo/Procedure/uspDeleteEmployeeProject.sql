/****** Object:  Procedure [dbo].[uspDeleteEmployeeProject]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeProject] 
	-- Add the parameters for the stored procedure here
	@id int, @projectID int, @status int, @hardDelete int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF(@hardDelete=0) BEGIN
		UPDATE EmployeeProject
		SET 
		isDeleted=@status
		WHERE EmployeeID= @id
		AND ProjectID= @projectID
	END ELSE
	BEGIN
		DELETE FROM EmployeeProject
		WHERE EmployeeID= @id
		AND ProjectID= @projectID
	END
END

