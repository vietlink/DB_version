/****** Object:  Procedure [dbo].[uspGetAttributesWithOptional]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAttributesWithOptional](@EntityId int, @HideEntryBased int, @sourceFilter varchar(50))      
      
/* ----------------------------------------------------------------------------------------------------------------      
 Name:  : $FunctionName      
 Description : Retrieve all records in the Attribute table.      
 Author(s) : Clark Sayers      
 Date  : 01-October-2004      
 Notes  :      
-------------------------------------------------------------------------------------------------------------------      
 REVISIONS :      
 $Author  : [CML]      
 $Date  : 30 March 2011      
 $History : Select new column (tab)      
 $Revision :      
-------------------------------------------------------------------------------------------------------------------      
 REVISIONS :      
 $Author  : [AC]      
 $Date  : 9 May 2012      
 $History : Select new column (dataentry)      
 $Revision :      
-------------------------------------------------------------------------------------------------------------------      
 REVISIONS :      
 $Author  : $      
 $Date  : $      
 $History : $      
 $Revision : $      
------------------------------------------------------------------------------------------------------------------- */      
      
AS   

DECLARE @sourceFilterId int = -1;
SELECT @sourceFilterId = id FROM AttributeSource WHERE code = @sourceFilter;   
      
if(@EntityId =0)      
      
  SELECT a.[id],       
    [entityid],       
    a.[code],       
    a.[name],       
    [columnname],       
    [shortname],       
    [longname],       
    [datatype],      
    [format],      
    [contenttype],      
    [sortorder],      
    [justification],      
    a.[usereditable],      
    [ispersonal],      
    [ismanagerial],      
    [tab],      
    [dataentry],    
    (select name from Tab where id= A.tab )as tabname,
	a.AttributeSourceID,
	a.FieldValueListID,
	ISNULL(IC.DATA_TYPE, '') as sqlDataType,
	IsOrgChartGroupField
  FROM 
	[dbo].[Attribute]  A    
   INNER JOIN
		Entity e
	ON
		e.id = a.entityid
    INNER JOIN
		INFORMATION_SCHEMA.COLUMNS IC 
	ON
		IC.TABLE_NAME = e.tablename and COLUMN_NAME = a.columnname

  WHERE (a.usereditable ='Y' OR a.usereditable ='X') AND (@sourceFilterId = -1 OR a.AttributeSourceID = @sourceFilterId) ORDER BY sortorder      
else      
      
  SELECT a.[id],       
    [entityid],       
    a.[code],       
    a.[name],       
    [columnname],       
    [shortname],       
    [longname],       
    [datatype],      
    [format],      
    [contenttype],      
    [sortorder],      
    [justification],      
    a.[usereditable],      
    [ispersonal],      
    [ismanagerial],      
    [tab],      
    [dataentry],    
    (select name from Tab where id= A.tab )as tabname,
	a.AttributeSourceID,
	a.FieldValueListID,
	ISNULL(IC.DATA_TYPE, '') as sqlDataType, 
	IsOrgChartGroupField
  FROM 
	[dbo].[Attribute]  A    
   INNER JOIN
		Entity e
	ON
		e.id = a.entityid
    INNER JOIN
		INFORMATION_SCHEMA.COLUMNS IC 
	ON
		IC.TABLE_NAME = e.tablename and COLUMN_NAME = a.columnname 
      
  wHERE (a.usereditable ='Y' OR a.usereditable ='X') and entityid =@EntityId  AND (@sourceFilterId = -1 OR a.AttributeSourceID = @sourceFilterId)  AND (@HideEntryBased = 0 OR (@HideEntryBased = 1 AND [ShowOnEntryGroups] = 1)) ORDER BY sortorder     
IF @@error != 0      
BEGIN      
 RAISERROR ('General Error', 18, 1)      
 RETURN 1        
END      
       
RETURN 0

