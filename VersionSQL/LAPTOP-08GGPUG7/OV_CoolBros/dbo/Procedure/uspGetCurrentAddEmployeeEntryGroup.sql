/****** Object:  Procedure [dbo].[uspGetCurrentAddEmployeeEntryGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCurrentAddEmployeeEntryGroup]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT id FROM EmployeeEntryGroups WHERE IsAddGroup = 1
END


