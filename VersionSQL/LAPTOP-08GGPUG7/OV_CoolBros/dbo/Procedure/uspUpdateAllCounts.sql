/****** Object:  Procedure [dbo].[uspUpdateAllCounts]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateAllCounts]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE
		epi
	SET
		epi.childcount = dbo.uspCheckHasChildren(epi.id),
		epi.directheadcount = dbo.uspCheckHasChildren(epi.id),
		epi.totalheadcount = dbo.uspGetTotalHeadCountRecursive(epi.positionid),
		epi.actualchildcount = dbo.uspGetTotalHeadCountRecursive2(epi.positionid),
		epi.actualtotalcount = dbo.uspGetTotalHeadCountRecursive3(epi.positionid)
	FROM
		EmployeePositionInfo epi

END

