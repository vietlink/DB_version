/****** Object:  Procedure [dbo].[uspGetDataItemByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDataItemByID](@id varchar(10))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @sql nvarchar(max)
	set @sql = 	
    'SELECT
		Id,
		[Type],
		(CASE [Type] WHEN 1 THEN ''Employee''
		WHEN 2 THEN ''Position''
		WHEN 3 THEN ''Employee Position''
		WHEN 4 THEN ''Picture Upload''
		END) as [LoadType],
		CASE WHEN (IsProcessed = 1 AND HasErrors = 0 AND HasIssues = 0) THEN ''Load successful'' WHEN (HasErrors = 1) THEN ''Load failed'' WHEN (IsProcessed = 0 AND HasErrors = 0 AND HasIssues = 0 AND ProcessStartDate IS NULL) THEN ''Load pending'' WHEN(IsProcessed = 0 AND HasErrors = 0 AND ProcessStartDate IS NOT NULL) THEN ''Load is currently processing'' WHEN HasIssues = 1 THEN ''Load successful with issues'' END as [Message],
		[CreatedBy],
		CreatedDate
	FROM
		DataFileUpload dfu WHERE Id =''' + @id + ''';';

	print @sql
	Execute sp_Executesql @sql;
END

