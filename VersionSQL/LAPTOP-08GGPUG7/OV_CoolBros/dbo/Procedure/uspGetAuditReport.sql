/****** Object:  Procedure [dbo].[uspGetAuditReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAuditReport](@groupBy varchar(200), @sortBy varchar(200), @dateFrom datetime, @dateTo datetime, @dataGroup varchar(255), @dataType varchar(255), @search varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		ald.AuditLogID,
		isnull(e.displayname, p.title) as displayname,
		isnull(a.shortname, ald.[description]) as Field,
		al.CreatedBy,
		al.CreatedDate,
		ald.OldValue,
		ald.NewValue,
		alt.[description] as [Type],
		alt.[grouping],
		al.ItemDesc
	FROM
		AuditLog al
	INNER JOIN
		AuditLogDetails ald
	ON
		al.id = ald.AuditLogID
	INNER JOIN
		AuditLogType alt
	ON
		alt.id = al.AuditLogTypeID
	LEFT OUTER JOIN
		Employee e
	ON
		e.id = al.employeeid
	LEFT OUTER JOIN
		Position p
	ON
		p.id = al.PositionID
	LEFT OUTER JOIN
		Attribute a
	ON
		a.id = ald.attributeid
	WHERE
		(Convert(DateTime, DATEDIFF(DAY, 0, al.CreatedDate)) BETWEEN @dateFrom AND @dateTo) AND NOT (ald.OldValue = '' AND ald.NewValue = '') AND NOT (ald.OldValue = ald.NewValue)
		AND ((@dataGroup = '' OR (alt.[grouping] = @dataGroup)) AND (@dataType = '' OR (alt.[description] = @dataType)))
		AND (@search = '' OR ((displayname like '%' + @search + '%') OR (alt.[description] like '%' + @search + '%') OR (isnull(a.shortname, ald.[description]) like '%' + @search + '%') OR (al.CreatedBy like '%' + @search + '%') OR (ald.OldValue like '%' + @search + '%') OR (al.ItemDesc like '%' + @search + '%') OR (ald.NewValue like '%' + @search + '%') ))
	ORDER BY
		CASE @groupBy WHEN 'displayname' THEN e.displayname END,
		CASE WHEN @groupBy = 'Field' THEN isnull(a.shortname, ald.[description]) END,
		CASE WHEN @groupBy = 'Type' THEN alt.[Description] END,
		CASE WHEN @groupBy = 'grouping' THEN alt.[grouping] END,
		CASE WHEN @groupBy = 'itemdesc' THEN al.ItemDesc END,
		CASE WHEN @groupBy = 'AuditLogID' THEN ald.AuditLogID END,
		CASE WHEN @sortBy = 'displayname' THEN e.displayname END,
		CASE WHEN @sortBy = 'Field' THEN isnull(a.shortname, ald.[description]) END,
		CASE WHEN @sortBy = 'CreatedBy' THEN al.CreatedBy END,
		CASE WHEN @sortBy = 'CreatedDate' THEN al.CreatedDate END desc,
		CASE WHEN @sortBy = 'OldValue' THEN ald.OldValue END,
		CASE WHEN @sortBy = 'NewValue' THEN ald.NewValue END,
		CASE WHEN @sortBy = 'Type' THEN alt.[Description] END,
		CASE WHEN @sortBy = 'grouping' then alt.[grouping] END,
		CASE WHEN @sortBy = 'itemdesc' then al.ItemDesc END,
		CASE WHEN @sortBy = 'AuditLogID' then ald.AuditLogID END

END

