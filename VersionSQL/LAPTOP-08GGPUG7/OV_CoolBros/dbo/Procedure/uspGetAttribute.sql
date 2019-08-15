/****** Object:  Procedure [dbo].[uspGetAttribute]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAttribute]
(
	@id	udtId
)

/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspGetAttribute
	Description	:	Get record in the Attribute table with the matching primary key.
	Author(s)	:	Clark Sayers
	Date		:	01-October-2004
	Notes		:
-------------------------------------------------------------------------------------------------------------------
	REVISIONS	:
	$Author		:	[CML]
	$Date		:	30 March 2011
	$History	:	Select new column (tab)
	$Revision	:
-------------------------------------------------------------------------------------------------------------------
	REVISIONS	:
	$Author		:	[AC]
	$Date		:	9 May 2012
	$History	:	Select new column (dataentry)
	$Revision	:
-------------------------------------------------------------------------------------------------------------------
	REVISIONS	:
	$Author		:	$
	$Date		:	$
	$History	:	$
	$Revision	:	$
------------------------------------------------------------------------------------------------------------------- */

AS

SELECT	[id], 
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
		[FieldValueListID]
FROM	[dbo].[Attribute]
WHERE	[id] = @id
	
IF @@error != 0
BEGIN
	
	RAISERROR ('uspGetAttribute: Error reading record from [orgview].[dbo].[Attribute]', 18, 1)
	
	RETURN 1		
END

RETURN 0

