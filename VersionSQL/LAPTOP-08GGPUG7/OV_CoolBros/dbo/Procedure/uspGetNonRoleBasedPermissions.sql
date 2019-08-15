/****** Object:  Procedure [dbo].[uspGetNonRoleBasedPermissions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetNonRoleBasedPermissions]
(
	@entityid	udtId
)

/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspGetDE_UserGrantedAttributes
	Description	:	Retrieve all attributes that the defined user has access to view, for Data Entry
	Author(s)	:	Alrie Coetzee
	Date		:	27-March-2012
	Notes		:
-------------------------------------------------------------------------------------------------------------------
	REVISIONS	:
	$Author		:	$
	$Date		:	$
	$History	:	$
	$Revision	:	$
------------------------------------------------------------------------------------------------------------------- */	
	
AS

SELECT	DISTINCT
		a.[id], 
		a.[entityid], 
		a.[code], 
		a.[name], 
		a.[columnname], 
		a.[shortname], 
		a.[longname], 
		a.[datatype],
		a.[format],
		a.[contenttype],
		a.[sortorder],
		a.[justification],
		a.[usereditable],
		a.[ispersonal],
		a.[ismanagerial],
		a.[tab],
		a.[dataentry]
from	[dbo].[Attribute] a
	
where	
	a.[usereditable] = 'Y'
order by a.sortorder

IF @@error != 0
BEGIN
	RAISERROR ('General Error', 18, 1)
	RETURN 1		
END

RETURN 0
