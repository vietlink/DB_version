/****** Object:  Procedure [dbo].[uspGetPositionEmployeeCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionEmployeeCount](@posId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @vacantId int = 0;
	SELECT @vacantId = id FROM Employee WHERE identifier = 'vacant';
    SELECT COUNT(*) as [count] FROM EmployeePosition ep INNER JOIN Employee e ON e.id = ep.employeeid
	INNER JOIN [status] s on s.[Description] = e.[status]
	WHERE s.IsVisibleChart = 1 AND ep.positionid = @posId AND ep.employeeid <> @vacantId AND ep.IsDeleted = 0 AND e.IsDeleted = 0;
END


