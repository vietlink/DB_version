/****** Object:  Procedure [dbo].[uspGetManagerIDByEmployeeID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspGetManagerIDByEmployeeID] 
	-- Add the parameters for the stored procedure here
	@empID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM EmployeePosition 
	WHERE employeeid= @empID AND IsDeleted =0 AND primaryposition='Y'
END

