/****** Object:  Procedure [dbo].[uspGetLocationList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLocationList]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT ROW_NUMBER() OVER(ORDER BY rs.location ASC) as id, rs.* FROM
	(
		SELECT
			DISTINCT case when location is null or location = '' then '(Blank)' else location end as location
		FROM
			Employee
		WHERE
			IsDeleted = 0
	) as rs
END

