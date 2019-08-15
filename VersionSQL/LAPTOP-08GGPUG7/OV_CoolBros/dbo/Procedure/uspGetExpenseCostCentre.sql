/****** Object:  Procedure [dbo].[uspGetExpenseCostCentre]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetExpenseCostCentre] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM CostCentres c
	WHERE c.IsDeleted=0 AND c.IsExpenseCostCentre=1
END

