/****** Object:  Procedure [dbo].[uspGetPayCostCentreIDByProjectID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayCostCentreIDByProjectID](@projectID int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		cc.*
	FROM
		Projects p
	INNER JOIN
		CostCentres cc
	ON
		p.PayCostCentreID = cc.ID
	WHERE
		p.ID = @projectID
END

