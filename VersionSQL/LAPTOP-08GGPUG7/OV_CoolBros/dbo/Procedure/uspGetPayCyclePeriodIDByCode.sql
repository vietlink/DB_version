/****** Object:  Procedure [dbo].[uspGetPayCyclePeriodIDByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspGetPayCyclePeriodIDByCode] 
	-- Add the parameters for the stored procedure here
	@code varchar(5)  
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ID
	FROM PayrollCyclePeriods
	WHERE Code= @code
END

