/****** Object:  Procedure [dbo].[uspSoftDeletePositions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSoftDeletePositions](@idList varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @idTable TABLE(id varchar(max));
	INSERT INTO @idTable SELECT splitdata FROM fnSplitString(@idList, ',');
 	UPDATE
		p
	SET
		p.IsDeleted = 1
	FROM
		Position p
	WHERE
	 	p.IsUnassigned <> 1 AND p.identifier NOT IN (SELECT id FROM @idTable)

	UPDATE
		ep
	SET 
		ep.IsDeleted = 1
	FROM
		EmployeePosition ep
	INNER JOIN
		Position p
	ON
		p.id = ep.positionid
	WHERE
	 	p.IsUnassigned <> 1 AND p.identifier NOT IN (SELECT id FROM @idTable)

END


