/****** Object:  Procedure [dbo].[uspGetPositionByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT p.*,
	(select isnull(count(ep.id), 0) from employeeposition ep inner join employee e on e.id = ep.employeeid where positionid = p.id and e.isdeleted = 0 and ep.isdeleted = 0 and e.identifier <> 'vacant') as EmployeeCount
	FROM Position p WHERE p.ID = @id;
END

