/****** Object:  Procedure [dbo].[uspGetAttributeByEntityAndColumnName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAttributeByEntityAndColumnName](@entityId int, @columnName varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM Attribute WHERE entityid = @entityId AND columnname = @columnName
END


