/****** Object:  Procedure [dbo].[uspAddUpdateEmployeeDetailIcon]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateEmployeeDetailIcon](@index int, @fileName varchar(256), @type int, @url varchar(256), @tooltip varchar(256), @groupId int, @attributeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM EmployeeDetailIcons WHERE IconIndex = @index) BEGIN
		UPDATE 
			EmployeeDetailIcons
		SET
			IconFileName = @fileName,
			IconType = @type,
			IconUrl = @url,
			IconTooltip = @tooltip,
			GroupID = @groupId,
			AttributeID = @attributeId
		WHERE
			IconIndex = @index	
	END
	ELSE
		INSERT INTO
		EmployeeDetailIcons(IconIndex, IconFileName, IconType, IconUrl, IconTooltip, GroupID, AttributeID)
			VALUES(@index, @fileName, @type, @url, @tooltip, @groupId, @attributeId);
	
END


