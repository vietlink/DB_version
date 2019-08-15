/****** Object:  Procedure [dbo].[uspUpdateAllPrimarySecondaryPositions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateAllPrimarySecondaryPositions]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE empCursor CURSOR FOR
		SELECT id FROM Employee WHERE IsDeleted = 0 AND Identifier <> 'Vacant' AND IsPlaceholder = 0
	OPEN empCursor;

	DECLARE @empId int;

	FETCH NEXT FROM empCursor
		INTO @empId

	WHILE @@FETCH_STATUS = 0 BEGIN
		EXEC dbo.uspSetCurrentPrimaryPosition @empId, 1
		EXEC dbo.uspSetSecondaryPositions @empId, 1
		FETCH NEXT FROM empCursor
			INTO @empId
	END

	CLOSE empCursor;
	DEALLOCATE empCursor;

	EXEC dbo.uspBuildPositionGrouplessHierarchy;
	EXEC dbo.uspUpdateAllCounts;
	EXEC dbo.uspSetEmptyParentEmpPos;
END
