/****** Object:  Procedure [dbo].[uspAddUpdateFieldValueListItem]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateFieldValueListItem](@id int, @value varchar(100), @parentId int) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (SELECT id FROM FieldValueListItem WHERE value = @value AND FieldValueListID = @parentId AND id <> @id AND IsDeleted = 0) BEGIN
		RETURN -1;
	END

	DECLARE @undoSoftDeleteID int = 0;
	SELECT @undoSoftDeleteID = id FROM FieldValueListItem WHERE value = @value AND FieldValueListID = @parentId AND id <> @id AND IsDeleted = 1
	IF(@undoSoftDeleteID > 0) BEGIN
		UPDATE FieldValueListItem SET IsDeleted = 0 WHERE id = @undoSoftDeleteID;
		RETURN @undoSoftDeleteID;
	END
    IF EXISTS (SELECT id FROM FieldValueListItem WHERE id = @id) BEGIN
		UPDATE FieldValueListItem SET value = @value WHERE id = @id
		RETURN @id;
	END
	ELSE
		INSERT INTO FieldValueListItem(value, FieldValueListID)
			VALUES(@value, @parentId);
		RETURN @@IDENTITY;
END


