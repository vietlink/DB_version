/****** Object:  Procedure [dbo].[uspGetDuplicateAccountPriority]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDuplicateAccountPriority](@identifier varchar(max), @accName varchar(max))
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @priority int = 0;
	IF EXISTS (SELECT id FROM employee WHERE identifier = @identifier AND accountname = @accName) BEGIN
		SET @priority = 3;
	END
	ELSE IF EXISTS(SELECT id FROM employee WHERE identifier = @identifier)
		SET @priority = 2;
	END
	SELECT @priority as [Priority]


