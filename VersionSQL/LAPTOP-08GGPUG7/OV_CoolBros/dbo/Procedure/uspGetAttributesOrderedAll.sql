/****** Object:  Procedure [dbo].[uspGetAttributesOrderedAll]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAttributesOrderedAll]  
/* ----------------------------------------------------------------------------------------------------------------  
 Name:  : uspGetAttributesOrderedAll  
 Description : Retrieves the Attribute(s) in their SortOrder.  
 Author(s) : CML  
 Date  : 24 May 2010  
 Notes  :   v2.2.8 A00091  
-------------------------------------------------------------------------------------------------------------------  
 REVISIONS :  
 $Author  : [AC]  
 $Date  : 9 May 2012  
 $History : Select new column (dataentry)  
 $Revision :  
------------------------------------------------------------------------------------------------------------------- */  
AS  
BEGIN  
 SET NOCOUNT ON  
  
 SELECT  
  a.[id],  
  e.[id] as 'entityid',  
  e.[name] as 'entityname',  
  a.[id] as 'attributeid',  
  a.[columnname] as 'attributecolumnname',  
  e.[name] + '.' + a.[longname] as 'name',  
  e.[usereditable] as 'entityusereditable',  
  a.[usereditable] as 'attributeusereditable',  
  a.[sortorder],  
  a.[tab],  
  a.[dataentry],
  cast(a.id as varchar) +'.'+ cast(a.[sortorder] as varchar) as value  
 FROM  
  [dbo].[Entity] e (NOLOCK) INNER JOIN [dbo].[Attribute] a (NOLOCK) ON e.[id] = a.[entityid] WHERE a.usereditable ='Y'  
 ORDER BY  
  a.[sortorder]  
  
 if @@error != 0  
 BEGIN  
  RAISERROR('General Error', 18, 1)  
  RETURN 1  
 END  
 RETURN 0  
END

