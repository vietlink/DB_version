/****** Object:  Procedure [dbo].[uspCheckEmployeeIdentifier]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckEmployeeIdentifier](@identifier varchar(255), @employeeid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT id FROM Employee WHERE Identifier = @identifier AND id <> @employeeid
END


