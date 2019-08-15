/****** Object:  Procedure [dbo].[uspGetEmployeePositionInfoByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeePositionInfoByID](@empPosId int, @loggedInPosID int, @userId int, @iAmManager bit, @hideByVisible int)
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

	SELECT 
	EP.[id],
	isnull(ep.[employeeid], 0) as employeeid,
	isnull(ep.[positionid], 0) as positionid,
	isnull(ep.[displaynameid], 0) as displaynameid,
	isnull(EP.[displayname], '') as displayname,
	isnull(ep.[employeeimageurlid], 0) as employeeimageurlid,
	isnull(ep.[employeeimageurl], '') as employeeimageurl,
	isnull(ep.[positiontitleid], 0) as positiontitleid,
	isnull(ep.[positiontitle], '') as positiontitle,
	isnull(e.[status], '') as [status],
	isnull(ep.[customfield1id], 0) as customfield1id,
	isnull(ep.[customfield1], '') as customfield1,
	isnull(ep.[customfield1value], '') as customfield1value,
	isnull(ep.[customfield2id], 0) as customfield2id,
	isnull(ep.[customfield2], '') as customfield2,
	isnull(ep.[customfield2value], '') as customfield2value,
	isnull(ep.[customfield3id], 0) as customfield3id,
	isnull(ep.[customfield3], '') as customfield3,
	isnull(ep.[customfield3value], '') as customfield3value,
	isnull(ep.[customfield4id], 0) as customfield4id,
	isnull(ep.[customfield4], '') as customfield4,
	isnull(ep.[customfield4value], '') as customfield4value,
	isnull(ep.[customicon1id], 0) as customicon1id,
	isnull(ep.[customicon1url], '') as customicon1url,
	isnull(ep.[customicon1tooltip], '') as customicon1tooltip,
	isnull(ep.[customnavigate1url], '') as customnavigate1url,
	isnull(ep.[customicon2id], 0) as customicon2id,
	isnull(ep.[customicon2url], '') as customicon2url,
	isnull(ep.[customicon2tooltip], '') as customicon2tooltip,
	isnull(ep.[customnavigate2url], '') as customnavigate2url,
	isnull(ep.[customicon3id], 0) as customicon3id,
	isnull(ep.[customicon3url], '') as customicon3url,
	isnull(ep.[customicon3tooltip], '') as customicon3tooltip,
	isnull(ep.[customnavigate3url], '') as customnavigate3url,
	isnull(ep.[customicon4id], 0) as customicon4id,
	isnull(ep.[customicon4url], '') as customicon4url,
	isnull(ep.[customicon4tooltip], '') as customicon4tooltip,
	isnull(ep.[customnavigate4url], '') as customnavigate4url,
	isnull(ep.[customicon5id], 0) as customicon5id,
	isnull(ep.[customicon5url], '') as customicon5url,
	isnull(ep.[customicon5tooltip], '') as customicon5tooltip,
	isnull(ep.[customnavigate5url], '') as customnavigate5url,
	isnull(ep.[emailid], 0) as emailid,
	isnull(ep.[email], '') as email,
	isnull(ep.[haschildren], 0) as haschildren,
	isnull(ep.[childcount], 0) as childcount,
	isnull(ep.[directheadcount], 0) as directheadcount,
	isnull(ep.[totalheadcount], 0) as [totalheadcount],
	isnull(ep.[directftecount], 0) as [directftecount],
	isnull(ep.[totalftecount], 0) as [totalftecount],
	isnull(ep.[positionparentid], 0) as positionparentid,
	isnull(EP.[availabilitymessage], '') as availabilitymessage,
	isnull(ep.[availabilityiconurl], '') as availabilityiconurl,
	isnull(AvS.name, '') as availabilitystatus,
	isnull(_ep.fte, 0.0) as fte,
	_ep.[Managerial],
	_ep.[primaryposition],
	_ep.[ExclFromSubordCount],
	ep.IsVisible,
	ep.IsAssistant,
	dbo.fnCheckPermission(@loggedInPosID, @userId, @AvailMsgViewId, ep.employeeid, ep.positionid, @iAmManager) AS PermAvailMsgView,
	dbo.fnCheckPermission(@loggedInPosID, @userId, @AvailMsgEditId, ep.employeeid, ep.positionid, @iAmManager) AS PermAvailMsgEdit,
	/*dbo.fnCheckPermission(@loggedInPosID, @userId, @DocEmpViewId, ep.employeeid, ep.positionid, @iAmManager) */ 0 AS PermDocView,
	/*dbo.fnCheckPermission(@loggedInPosID, @userId, @CompetencyViewId, ep.employeeid, ep.positionid, @iAmManager) */ 0 AS PermCompetencyView,
	/*dbo.fnCheckPermission(@loggedInPosID, @userId, @ViewComplianceReportId, ep.employeeid, ep.positionid, @iAmManager) */ 0 AS PermComplianceReport,
	/*dbo.fnCheckPermission(@loggedInPosID, @userId, @ViewComplianceId, ep.employeeid, ep.positionid, @iAmManager) */ 0 AS PermCompliance,
	/*dbo.fnCheckPermission(@loggedInPosID, @userId, @ViewEmailId, ep.employeeid, ep.positionid, @iAmManager) */ 1 AS PermEmail,
	e.firstnamepreferred as preferredname,
	e.surname,
	e.[type],
	e.firstname,
	e.isplaceholder,
	e.isdeleted,
	ep.actualchildcount,
	_ep.ExclFromSubordCount,
	ep.ActualTotalCount
	FROM EmployeePositionInfo ep
	INNER JOIN
	Position p
	ON
	p.id = ep.positionid
	INNER JOIN
	Employee e
	ON
	e.id = ep.employeeid
	INNER JOIN
	EmployeePosition _ep
	ON
	_ep.id = ep.id
	LEFT OUTER JOIN AvailabilityStatus AvS 
	on AvS.id = ep.availabilitystatus 
	WHERE ep.id = @empPosId AND-- AND e.IsDeleted = 0 AND p.IsDeleted = 0 AND _ep.IsDeleted = 0 AND
	((@hideByVisible = 1 AND ep.IsVisible = 1) OR @hideByVisible = 0)
	END

