/****** Object:  Procedure [dbo].[uspGetAttributes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAttributes](@EntityId int, @ignoreUrl int = 0)  
  
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
  
DECLARE @excludeSourceId int = -1;
SELECT @excludeSourceId = id FROM AttributeSource WHERE code = 'notused';
if(@EntityId =0)  
  
  SELECT [id],   
    [entityid],   
    [code],   
    [name],   
    [columnname],   
    [shortname],   
    [longname],   
    [datatype],  
    [format],  
    [contenttype],  
    [sortorder],  
    [justification],  
    [usereditable],  
    [ispersonal],  
    [ismanagerial],  
    [tab],  
    [dataentry],
    (select name from Tab where id= A.tab )as tabname
  FROM [dbo].[Attribute]  A
  
  wHERE usereditable ='Y' AND ISNULL(a.AttributeSourceID, 0) <> @excludeSourceId
  ORDER BY shortname
else  
  
  SELECT [id],   
    [entityid],   
    [code],   
    [name],   
    [columnname],   
    [shortname],   
    [longname],   
    [datatype],  
    [format],  
    [contenttype],  
    [sortorder],  
    [justification],  
    [usereditable],  
    [ispersonal],  
    [ismanagerial],  
    [tab],  
    [dataentry],
    (select name from Tab where id= A.tab )as tabname  
  FROM [dbo].[Attribute]  A
  
  wHERE usereditable ='Y' and entityid =@EntityId AND ISNULL(a.AttributeSourceID, 0) <> @excludeSourceId   
  AND
  ((@ignoreUrl = 0) OR (@ignoreUrl = 1 AND contenttype <> 'URL'))
  ORDER BY shortname
IF @@error != 0  
BEGIN  
 RAISERROR ('General Error', 18, 1)  
 RETURN 1    
END  
   
RETURN 0

