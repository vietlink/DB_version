/****** Object:  Procedure [dbo].[uspAddPreferenceDefaultValues]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddPreferenceDefaultValues]
AS
BEGIN

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customfield1';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customfield2';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customfield3';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customfield4';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon1url';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon2url';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon3url';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon4url';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon5url';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'employeecontact.workemail'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'email';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'employee.displayname'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'displayname';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'position.title'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'positiontitle';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customfield1value';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customfield2value';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customfield3value';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customfield4value';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon1tooltip';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon2tooltip';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon3tooltip';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon4tooltip';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon5tooltip';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customnavigate1url';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customnavigate2url';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customnavigate3url';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customnavigate4url';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customnavigate5url';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'employee.availabilitystatusid'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'availabilitystatus';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'employee.availabilitymessage'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'availabilitymessage';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'Employee.picture'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'employeeimageurl';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'Position.parentid'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'positionparentid';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'EmployeePosition.id'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'id';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'Employee.id'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'employeeid';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'Position.id'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'positionid';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Lookup',
		'AvailabilityStatus.icon'
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'availabilityiconurl';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code]		=	'customfield1id';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code]		=	'customfield2id';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code]		=	'customfield3id';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'None',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customfield4id';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Value',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon1id';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Value',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon2id';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Value',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon3id';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Value',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon4id';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Value',
		null
FROM	[dbo].[Preference] p
WHERE	p.[code] = 'customicon5id';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Value',
		a.[id]
FROM	[dbo].[Preference] p,
		[dbo].[Attribute] a,
		[dbo].[Entity] e
WHERE	e.[id]			=	a.[entityid]
AND		e.[code]		=	'e'
AND		a.[columnname]	=	'displayname'
AND		p.[code]		=	'displaynameid';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Value',
		a.[id]
FROM	[dbo].[Preference] p,
		[dbo].[Attribute] a,
		[dbo].[Entity] e
WHERE	e.[id]			=	a.[entityid]
AND		e.[code]		=	'e'
AND		a.[columnname]	=	'employeeimageurl'
AND		p.[code]		=	'employeeimageurlid';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Value',
		a.[id]
FROM	[dbo].[Preference] p,
		[dbo].[Attribute] a,
		[dbo].[Entity] e
WHERE	e.[id]			=	a.[entityid]
AND		e.[code]		=	'p'
AND		a.[columnname]	=	'title'
AND		p.[code]		=	'positiontitleid';

INSERT INTO ApplicationPreference
(	preferenceid, type, value )
SELECT	p.id, 
		'Value',
		a.[id]
FROM	[dbo].[Preference] p,
		[dbo].[Attribute] a,
		[dbo].[Entity] e
WHERE	e.[id]			=	a.[entityid]
AND		e.[code]		=	'ec'
AND		a.[columnname]	=	'workemail'
AND		p.[code]		=	'emailid';
END
