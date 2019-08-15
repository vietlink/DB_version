/****** Object:  Procedure [dbo].[uspGetEmployeePositionByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeePositionByID](@empPosID int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ep.*, p.title as positiontitle FROM EmployeePosition ep
	INNER JOIN
	Position p
	ON p.id = ep.positionid
	WHERE ep.id = @empPosID
END


