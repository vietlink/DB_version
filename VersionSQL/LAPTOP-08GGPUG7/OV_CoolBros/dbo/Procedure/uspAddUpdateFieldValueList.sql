/****** Object:  Procedure [dbo].[uspAddUpdateFieldValueList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateFieldValueList](@id int, @description varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS(SELECT id FROM FieldValueList WHERE [description] = @description AND id <> @id AND IsDeleted = 0) BEGIN
		RETURN -1;
	END

	DECLARE @undoSoftDeleteId int = 0;
	SELECT @undoSoftDeleteId = id FROM FieldValueList WHERE [description] = @description AND id <> @id AND IsDeleted = 1;
	IF(@undoSoftDeleteId > 0) BEGIN
		UPDATE FieldValueList SET IsDeleted = 0 WHERE id = @undoSoftDeleteId;
		RETURN @undoSoftDeleteId;
	END

	IF @id = 0 BEGIN
	    INSERT INTO FieldValueList([Description])
			VALUES(@description);
		RETURN @@IDENTITY;
		END
	ELSE
		UPDATE FieldValueList
			SET [Description] = @description
		WHERE
			ID = @id;
		RETURN @id;

END


