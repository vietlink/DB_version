/****** Object:  Procedure [dbo].[uspGetAvailabilityStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAvailabilityStatus]
	
(
	@EmpPosid	udtId)


/* ----------------------------------------------------------------------------------------------------------------
	Name:		:	uspGetAvailabilityStatus
	Description	:	Get record in the AvailabilityStatus table with the matching primary key.
	Author(s)	:	Clark Sayers
	Date		:	01-October-2004
	Notes		:
-------------------------------------------------------------------------------------------------------------------
	REVISIONS	:
	$Author		:	$
	$Date		:	$
	$History	:	$
	$Revision		:	$
------------------------------------------------------------------------------------------------------------------- */
	
	
AS

SELECT	A.[id], 
	[code], 
	[name],
	[icon],
	E.availabilityiconurl,
	E.availabilitymessage,
	E.availabilitystatus,
	E.displayname,
	E.UpdatedAvailabilityMessageDateTime
FROM	[dbo].[AvailabilityStatus] A join EmployeePositionInfo E on E.availabilitystatus=A.id 
WHERE	E.id = @EmpPosid
	
IF @@error != 0
BEGIN
	RAISERROR ('uspGetAvailabilityStatus: Error reading record from [orgview].[dbo].[AvailabilityStatus]', 18, 1)
	RETURN 1		
END
	
RETURN 0

