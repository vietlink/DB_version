/****** Object:  Procedure [dbo].[uspAddUpdatePositionEntryGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdatePositionEntryGroup](@id int, @description varchar(50), @code varchar(10), @oldCode varchar(10), @isAddGroup bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @retId int = @id;

    IF @id > 0 BEGIN
		UPDATE
			PositionEntryGroups
		SET
			Description = @description,
			Code = @code,
			IsAddGroup = @isAddGroup
		WHERE
			id = @id;

		UPDATE 
			Attribute
		SET
			name = 'Data Entry - ' + @description,
			columnname = 'Data Entry - ' + @description,
			shortname = 'Data Entry - ' + @description,
			longname = 'Data Entry - ' + @description,
			code = '#' + @code
		WHERE
			code = '#' + @oldCode
	END
	ELSE
	BEGIN
		INSERT INTO PositionEntryGroups([description], code, IsAddGroup, sortorder)
			VALUES(@description, @code, @isAddGroup, (SELECT ISNULL(MAX(sortorder), 0) + 1 FROM PositionEntryGroups))
		SET @retId = @@IDENTITY;

		DECLARE @entityId int = 0;
		SELECT @entityId = id FROM Entity WHERE tablename = 'PositionEntryGroups'
		DECLARE @sortOrder int = 1;
		SELECT @sortOrder = MAX(SortOrder) FROM Attribute WHERE entityid = @entityId;
		IF @sortOrder IS NULL BEGIN
			SET @sortOrder = 1;
		END
		ELSE
			SET @sortOrder = @sortOrder + 1
		SET @description = 'Data Entry - ' + @description
		INSERT INTO Attribute(entityid, code, name, columnname, shortname, longname, datatype, [format], contenttype, sortorder, justification, usereditable, ispersonal, ismanagerial, dataentry, IsPolicyBased, tab)
			VALUES(@entityId, '#' + @code, @description, @description, @description, @description, 'AnsiString', '', 'Value',
			@sortOrder, 'Left', 'Y', 'N', 'N', 'N', 0, 0)
		DECLARE @attId int;
		SET @attId = @@IDENTITY;
		DECLARE @sysAdminId int = 0;
		SELECT TOP 1 @sysAdminId = id FROM [Role] WHERE type = 'BuiltIn'
		IF @sysAdminId <> 0 BEGIN
			INSERT INTO RoleAttribute(roleid, attributeid, granted)
				VALUES(@sysAdminId, @attId, 'Y');
		END
	END

	RETURN @retId;
END


