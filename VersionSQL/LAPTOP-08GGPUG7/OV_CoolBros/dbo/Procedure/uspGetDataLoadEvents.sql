/****** Object:  Procedure [dbo].[uspGetDataLoadEvents]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDataLoadEvents](@loadType varchar(10), @status varchar(30), @dateFrom varchar(100), @dateTo varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @sql nvarchar(max)
	set @sql = 	
    'SELECT rs.* FROM (SELECT
		Id,
		[Type],
		(CASE [Type] WHEN 1 THEN ''Employee''
		WHEN 2 THEN ''Position''
		WHEN 3 THEN ''Employee Position''
		WHEN 4 THEN ''Picture Upload''
		WHEN 6 THEN ''Additional Employee''
		WHEN 7 THEN ''Additional Position''
		WHEN 8 THEN ''Additional Employee Position''
		END) as [LoadType],
		CASE WHEN (IsProcessed = 1 AND HasErrors = 0 AND HasIssues = 0) THEN ''Load successful'' WHEN (HasErrors = 1) THEN ''Load failed'' WHEN (IsProcessed = 0 AND HasErrors = 0 AND HasIssues = 0 AND ProcessStartDate IS NULL) THEN ''Load pending'' WHEN(IsProcessed = 0 AND HasErrors = 0 AND ProcessStartDate IS NOT NULL) THEN ''Load is currently processing'' WHEN HasIssues = 1 THEN ''Load successful with issues'' END as [Message],
		[CreatedBy],
		CreatedDate,
		ProcessedDate
	FROM
		DataFileUpload dfu WHERE (CreatedDate BETWEEN ''' +@dateFrom+ ''' AND '''+ @dateTo+''') '

	IF @loadType <> ''
	SET @sql += 'AND ([Type] = ''' +@loadType+ ''') '
	SET @sql += ') as RS '
	IF @status <> ''
	SET @sql += ' WHERE (rs.[Message] = '''+@status+''') '
	SET @sql += 'ORDER BY rs.CreatedDate DESC'
	print @sql
	Execute sp_Executesql @sql;
END

