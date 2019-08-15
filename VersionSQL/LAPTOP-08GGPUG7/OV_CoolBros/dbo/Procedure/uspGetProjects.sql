/****** Object:  Procedure [dbo].[uspGetProjects]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetProjects]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT p.*, c.[description] as Client, cc.[Description] as PayCostCentre FROM
		Projects p
	INNER JOIN 
		Clients c 
	ON 
		p.ClientID = c.ID
	LEFT OUTER JOIN
		CostCentres cc
	ON
		cc.ID = p.PayCostCentreID
END

