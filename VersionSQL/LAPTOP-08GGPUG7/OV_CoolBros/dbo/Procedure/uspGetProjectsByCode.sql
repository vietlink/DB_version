/****** Object:  Procedure [dbo].[uspGetProjectsByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetProjectsByCode] 
	-- Add the parameters for the stored procedure here
	@filter varchar(10), @client int, @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
		SELECT * FROM Projects WHERE Code=@filter AND IsDeleted= @status AND ClientID=@client
	
END

