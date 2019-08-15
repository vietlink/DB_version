/****** Object:  Procedure [dbo].[uspGetDirectIDs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDirectIDs](@empPosId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @posId int = 0;
	SELECT @posId = positionid FROM EmployeePositionInfo WHERE id = @empPosId
	SELECT epi.id FROM EmployeePositionInfo epi
	INNER JOIN
	Position p
	ON
	p.id = epi.positionid
	INNER JOIN
	Employee e
	ON
	e.id = epi.employeeid
	INNER JOIN
	EmployeePosition ep
	ON
	ep.id = epi.id
	WHERE e.isplaceholder = 0 and positionparentid = @posId AND p.IsUnassigned = 0 AND ep.IsDeleted = 0 AND p.IsDeleted = 0 AND e.IsDeleted = 0 and epi.IsVisible = 1
END

