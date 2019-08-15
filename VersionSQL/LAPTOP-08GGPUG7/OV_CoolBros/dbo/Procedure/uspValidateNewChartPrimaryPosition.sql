/****** Object:  Procedure [dbo].[uspValidateNewChartPrimaryPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspValidateNewChartPrimaryPosition](@editId int, @employeeid int, @positionid int, @datefrom datetime, @dateto datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @searchId int = null;

	DECLARE @oneUnderId int = null;

	SELECT top 1 @oneUnderId = id FROM EmployeePositionHistory WHERE Employeeid = @employeeid AND startdate < @datefrom AND primaryposition = 'Y' ORDER BY startdate DESC

	DECLARE @commencementDate datetime;
	SELECT TOP 1 @commencementDate = commencement FROM Employee WHERE id = @employeeid;

	IF @dateFrom < @commencementDate BEGIN
		SELECT convert(nvarchar(20), @commencementDate, 103) as result
		RETURN;
	END

	SELECT
		@searchId = eph.id
	FROM
		EmployeePositionHistory eph
	WHERE
		eph.Employeeid = @employeeid AND primaryposition = 'Y'
		AND
		((eph.StartDate BETWEEN @datefrom AND isnull(@dateto, '12-31-9999'))
		OR
		eph.EndDate BETWEEN @datefrom AND isnull(@dateto, '12-31-9999')
		OR
		(eph.EndDate = @dateto OR eph.StartDate = @datefrom)
		)
		AND eph.id <> @editId AND eph.id <> isnull(@oneUnderId, 0);

	IF @searchId IS NULL AND @oneUnderId IS NOT NULL BEGIN
		SELECT
			@searchId = eph.id
		FROM
			EmployeePositionHistory eph
		WHERE
			eph.id = @oneUnderId AND eph.startdate >= @datefrom
	END

	IF @searchId IS NULL BEGIN

		IF EXISTS (SELECT TOP 1 ID FROM EmployeePositionHistory WHERE employeeid = @employeeid and startdate > @dateto) BEGIN
			SELECT
				@searchId = eph.id
			FROM
				EmployeePositionHistory eph
			WHERE
				eph.Employeeid = @employeeid AND primaryposition = 'Y'
				AND
				DATEDIFF(day,@dateto,eph.startdate) = 1 
				AND 
				eph.id <> @editId;
		END
		ELSE BEGIN
			SET @searchId = 0;
		END

		IF @searchId IS NULL BEGIN
			SELECT '-1' as result
		END
		ELSE BEGIN
			SELECT '0' as result
		END
	END ELSE BEGIN
		SELECT cast(ISNULL(@searchId, 0) as varchar(100)) as result
	END
	
END


