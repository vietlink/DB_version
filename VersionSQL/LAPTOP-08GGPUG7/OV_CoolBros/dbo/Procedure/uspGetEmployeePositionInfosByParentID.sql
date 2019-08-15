/****** Object:  Procedure [dbo].[uspGetEmployeePositionInfosByParentID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeePositionInfosByParentID](@parentID int, @loggedInPosID int, @userId int, @iAmManager bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @AvailMsgViewId int = dbo.fnGetAttributeIdByCode('availmessage-view');
	DECLARE @AvailMsgEditId int = dbo.fnGetAttributeIdByCode('availmessage-edit');
	--DECLARE @DocEmpViewId int = dbo.fnGetAttributeIdByCode('DocumentsEmployeeView');
	--DECLARE @CompetencyViewId int = dbo.fnGetAttributeIdByCode('competency-view');
	--DECLARE @ViewComplianceReportId int = dbo.fnGetAttributeIdByCode('ViewComplianceReport');
	--DECLARE @ViewComplianceId int = dbo.fnGetAttributeIdByCode('ViewCompliances');
	--DECLARE @ViewEmailId int = dbo.fnGetAttributeIdByCode('workemail');

    SELECT EP.[id],
	isnull(ep.[employeeid], 0) as employeeid,
	isnull(ep.[positionid], 0) as positionid,
	isnull([displaynameid], 0) as displaynameid,
	isnull(EP.[displayname], '') as displayname,
	isnull([employeeimageurlid], 0) as employeeimageurlid,
	isnull([employeeimageurl], '') as employeeimageurl,
	isnull([positiontitleid], 0) as positiontitleid,
	isnull([positiontitle], '') as positiontitle,
	isnull([customfield1id], 0) as customfield1id,
	isnull([customfield1], '') as customfield1,
	isnull([customfield1value], '') as customfield1value,
	isnull([customfield2id], 0) as customfield2id,
	isnull([customfield2], '') as customfield2,
	isnull([customfield2value], '') as customfield2value,
	isnull([customfield3id], 0) as customfield3id,
	isnull([customfield3], '') as customfield3,
	isnull([customfield3value], '') as customfield3value,
	isnull([customfield4id], 0) as customfield4id,
	isnull([customfield4], '') as customfield4,
	isnull([customfield4value], '') as customfield4value,
	isnull([customicon1id], 0) as customicon1id,
	isnull([customicon1url], '') as customicon1url,
	isnull([customicon1tooltip], '') as customicon1tooltip,
	isnull([customnavigate1url], '') as customnavigate1url,
	isnull([customicon2id], 0) as customicon2id,
	isnull([customicon2url], '') as customicon2url,
	isnull([customicon2tooltip], '') as customicon2tooltip,
	isnull([customnavigate2url], '') as customnavigate2url,
	isnull([customicon3id], 0) as customicon3id,
	isnull([customicon3url], '') as customicon3url,
	isnull([customicon3tooltip], '') as customicon3tooltip,
	isnull([customnavigate3url], '') as customnavigate3url,
	isnull([customicon4id], 0) as customicon4id,
	isnull([customicon4url], '') as customicon4url,
	isnull([customicon4tooltip], '') as customicon4tooltip,
	isnull([customnavigate4url], '') as customnavigate4url,
	isnull([customicon5id], 0) as customicon5id,
	isnull([customicon5url], '') as customicon5url,
	isnull([customicon5tooltip], '') as customicon5tooltip,
	isnull([customnavigate5url], '') as customnavigate5url,
	isnull([emailid], 0) as emailid,
	isnull([email], '') as email,
	isnull([haschildren], 0) as haschildren,
	isnull([childcount], 0) as childcount,
	isnull([directheadcount], 0) as directheadcount,
	isnull([totalheadcount], 0) as [totalheadcount],
	isnull([directftecount], 0) as [directftecount],
	isnull([totalftecount], 0) as [totalftecount],
	isnull([positionparentid], 0) as positionparentid,
	isnull(EP.[availabilitymessage], '') as availabilitymessage,
	isnull([availabilityiconurl], '') as availabilityiconurl,
	isnull(AvS.name, '') as availabilitystatus,
	IsVisible,
	IsAssistant,
	 dbo.fnCheckPermission(@loggedInPosID, @userId, @AvailMsgViewId, ep.employeeid, ep.positionid, @iAmManager) AS PermAvailMsgView,
	 dbo.fnCheckPermission(@loggedInPosID, @userId, @AvailMsgEditId, ep.employeeid, ep.positionid, @iAmManager) AS PermAvailMsgEdit,
	/* dbo.fnCheckPermission(@loggedInPosID, @userId, @DocEmpViewId, employeeid, positionid, @iAmManager) */ 0 AS PermDocView,
	/* dbo.fnCheckPermission(@loggedInPosID, @userId, @CompetencyViewId, employeeid, positionid, @iAmManager) */ 0 AS PermCompetencyView,
	/* dbo.fnCheckPermission(@loggedInPosID, @userId, @ViewComplianceReportId, employeeid, positionid, @iAmManager) */ 0 AS PermComplianceReport,
	/* dbo.fnCheckPermission(@loggedInPosID, @userId, @ViewComplianceId, employeeid, positionid, @iAmManager) */ 0 AS PermCompliance,
	/* dbo.fnCheckPermission(@loggedInPosID, @userId, @ViewEmailId, employeeid, positionid, @iAmManager) */ 1 AS PermEmail,
	e.isplaceholder,
	ep.actualchildcount,
	_ep.ExclFromSubordCount,
	ep.ActualTotalCount
	FROM EmployeePositionInfo ep
	INNER JOIN EmployeePosition _ep ON _ep.id = ep.id
	INNER JOIN Employee e on e.id = ep.employeeid
	LEFT OUTER JOIN AvailabilityStatus AvS 
	on AvS.id = ep.availabilitystatus WHERE ep.IsVisible = 1 AND ep.positionparentid = @parentID ORDER BY ep.displayname
END

