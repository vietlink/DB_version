/****** Object:  Procedure [dbo].[uspIsDuplicatedProject]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspIsDuplicatedProject] 
	-- Add the parameters for the stored procedure here
	@code varchar(10), @client int, @id int,  @ReturnValue int out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @ReturnValue=( SELECT COUNT(*)
	FROM Projects
	WHERE Code= @code
	AND ClientID= @client
	AND ID <> @id)
END

