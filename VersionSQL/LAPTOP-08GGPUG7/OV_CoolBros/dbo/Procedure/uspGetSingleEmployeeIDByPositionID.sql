/****** Object:  Procedure [dbo].[uspGetSingleEmployeeIDByPositionID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSingleEmployeeIDByPositionID](@posId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 employeeid FROM EmployeePosition 
	WHERE positionid = @posId
END


