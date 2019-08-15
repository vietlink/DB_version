/****** Object:  Procedure [dbo].[uspAddUpdateEmployeeDetailField]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateEmployeeDetailField](@groupId int, @attributeId int, @section int, @field int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT * FROM EmployeeDetailFields WHERE Section = @section AND Field = @field) BEGIN
		UPDATE 
			EmployeeDetailFields
		SET
			AttributeID = @attributeId,
			GroupID = @groupId
		WHERE
			Section = @section
			AND
			Field = @field
	END
	ELSE
		INSERT INTO EmployeeDetailFields(GroupID, AttributeID, Section, Field)
			VALUES(@groupId, @attributeId, @section, @field)
END


