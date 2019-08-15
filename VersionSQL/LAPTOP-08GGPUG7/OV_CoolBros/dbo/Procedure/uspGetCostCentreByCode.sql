/****** Object:  Procedure [dbo].[uspGetCostCentreByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCostCentreByCode] 
	-- Add the parameters for the stored procedure here
	@filter varchar(10), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
		SELECT * from CostCentres where Code=@filter and IsDeleted= @status
	
END

