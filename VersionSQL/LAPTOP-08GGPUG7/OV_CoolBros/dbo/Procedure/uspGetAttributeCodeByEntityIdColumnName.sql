/****** Object:  Procedure [dbo].[uspGetAttributeCodeByEntityIdColumnName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAttributeCodeByEntityIdColumnName](@entityId int, @columnName varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT code FROM Attribute WHERE entityid = @entityId AND columnname = @columnName
END


