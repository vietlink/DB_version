/****** Object:  Function [dbo].[fnGetForeignTable]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetForeignTable] 
(	
	-- Add the parameters for the function here
	@tableName varchar(max)
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT
		ROW_NUMBER() OVER (ORDER BY OBJECT_NAME(f.parent_object_id)) as ID,
		OBJECT_NAME(f.parent_object_id) TableName,
		COL_NAME(fc.parent_object_id,fc.parent_column_id) ColName 
	FROM 
		sys.foreign_keys AS f
	INNER JOIN 
		sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
	INNER JOIN 
		sys.tables t ON t.OBJECT_ID = fc.referenced_object_id
	WHERE 
		OBJECT_NAME (f.referenced_object_id) = @tableName
)

