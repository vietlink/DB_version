/****** Object:  Procedure [dbo].[uspGetSelectNewPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSelectNewPosition](@search varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @unassignedId int = 0;
	SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1
	DECLARE @vacantId int = 0;
	SELECT @vacantId = id FROM Employee WHERE identifier = 'Vacant';

	SELECT id, title, identifier, location,
	(select count(id) from employeeposition where positionid = p.id and employeeid <> @vacantId and isdeleted = 0) as numberofpeople
	FROM Position p
	WHERE isdeleted = 0 and
	(title LIKE '%' + @search + '%' OR identifier like '%' + @search + '%' OR location like '%' + @search + '%')
	ORDER BY title
END


