/****** Object:  Procedure [dbo].[uspDeleteEmployeeEntrySection]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeEntrySection](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @code varchar(20);
	SELECT @code = Code FROM EmployeeEntryGroups WHERE id = @id;
	SET @code = '#' + @code;

	DECLARE @attId int = 0;
	SELECT @attId = id FROM Attribute WHERE code = @code;
	DELETE FROM RoleAttribute WHERE attributeid = @attId;
	DELETE FROM Attribute WHERE id = @attId;

    DELETE FROM EmployeeEntryGroupRelations WHERE EmployeeEntryGroupID = @id;
	DELETE FROM EmployeeEntryGroups WHERE id = @id;
END

