/****** Object:  Procedure [dbo].[uspGetAllCostCentre]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllCostCentre] 
	-- Add the parameters for the stored procedure here	
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
	IF (@id=0) BEGIN
		SELECT * from CostCentres WHERE IsDeleted=0 and IsPayrollCostCentre=1 ORDER BY Description
	END
	ELSE BEGIN
		SELECT c.* from CostCentres c 
		INNER JOIN Projects p ON c.ID= p.PayCostCentreID
		WHERE p.ID= @id
		UNION
		SELECT * from CostCentres WHERE IsDeleted=0 and IsPayrollCostCentre=1 
		ORDER BY c.Description
	END
		
	
END

