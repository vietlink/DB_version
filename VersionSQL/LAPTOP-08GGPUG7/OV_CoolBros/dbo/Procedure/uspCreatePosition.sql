/****** Object:  Procedure [dbo].[uspCreatePosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCreatePosition](@identifier varchar(50))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT ID FROM Position WHERE identifier = @identifier) BEGIN
		RETURN -1;
	END

	DECLARE @unassignedId int = 0;
	DECLARE @unassignedCode varchar(50);
	SELECT @unassignedId = id, @unassignedCode = identifier FROM Position WHERE IsUnassigned = 1;
	INSERT INTO Position(identifier, parentid, parentpositionidentifier, title, [description], [type], [DefaultExclFromSubordCount], isassistant)
		VALUES(@identifier, @unassignedId, @unassignedCode, '', '', '', 'N', 'N');
	RETURN @@IDENTITY;
END


