/****** Object:  Procedure [dbo].[uspSetSoftDeleteFieldValueListItem]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetSoftDeleteFieldValueListItem](@id int, @softDelete bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE FieldValueListItem SET IsDeleted = @softDelete WHERE id = @id;
END


