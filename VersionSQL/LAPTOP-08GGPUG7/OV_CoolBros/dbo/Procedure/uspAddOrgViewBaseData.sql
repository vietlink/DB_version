/****** Object:  Procedure [dbo].[uspAddOrgViewBaseData]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddOrgViewBaseData](@TYPE int)
AS
BEGIN

if(@TYPE =2)--Deleted Data and Preference
BEGIN
	exec uspAddPreferenceDefaultValues
END
ELSE IF (@TYPE =3)
BEGIN

/*Base Data -03-01-2014*/
INSERT INTO Position (title, description, type, isassistant, orgunit1, orgunit2, orgunit3, identifier, iFlag, IsVisibleChart, IsUnassigned, parentid)
VALUES('Unassigned', '', '', 'N', '', '', '', 'Unassigned', 1, 0, 1, 1);

INSERT INTO Employee (firstname, surname, displayname, picture, accountname, status, type, availabilitystatusid, identifier, iflag)
VALUES('Vacant', 'Vacant', 'Vacant', 'no_pic.gif', 'Vacant', 'Vacant', 'Permanent', 1, 'VACANT', 1)

INSERT INTO [Status] (IsVisibleChart, Code, [Description], [Type], DoSoftDelete)
VALUES(1, 'A', 'Active', 'Employee', 0)
INSERT INTO [Status] (IsVisibleChart, Code, [Description], [Type], DoSoftDelete)
VALUES(0, 'I', 'Inactive', 'Employee', 0)
INSERT INTO [Status] (IsVisibleChart, Code, [Description], [Type], DoSoftDelete)
VALUES(0, 'T', 'Terminated', 'Employee', 0)

/*******************************************Adding USER************************************************************/
insert into [User](authenticationmethodid,displayname,accountname,password,enabled,usereditable,type)
values(2,'System Administrator','sysadmin','6396CE47B4D8FFC168EF41512EAEB4E8','Y','Y','BuiltIn')
/*******************************************Adding ROLE***********************************************************/

insert into Role(code,name,description,type,enabled,usereditable)
values('Sys Admin','System Administrator','Members of this role have System Administration privileges.','BuiltIn','Y','Y')
/********************************************ROLE USER***********************************************************/
insert into RoleUser(roleid,userid)
values(1,1)
/******************************************POLICY MODULES *************************************************************/

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Users','Admin','~/Admin/Users.aspx')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Roles','Admin','~/Admin/Roles.aspx')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Employee Groups','Admin','~/Admin/EmployeeGroup.aspx')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Active Directory Group','Admin','~/Admin/ActiveDirectory.aspx')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Preferences','Admin','~/Admin/Preferences.aspx')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Update Preference','Admin','~/Admin/UpdatePreference.aspx')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Attributes','Admin','~/Admin/default.aspx')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Application Settings','Admin','~/Admin/Settings.aspx')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Event Log','Admin','~/Admin/Eventlog.aspx')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Search','Home','')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Print','Home','')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Employee Data Entry','DataEntry','')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Position Data Entry','DataEntry','')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Employee Position','DataEntry','')

insert into PolicyModules(Modulename,Sectioname,PageURL )
values('Position Hierarchy','DataEntry','')
/*******************************************POLICIES************************************************************/
insert into Policy(ModuleId,code,name,description,type) values(1,'Create','Create User','Role can create a new User','Role')
insert into Policy(ModuleId,code,name,description,type) values(1,'Edit','Edit User','Role can edit existing Users','Role')
insert into Policy(ModuleId,code,name,description,type) values(1,'Delete','Delete User','Role can delete existing Users','Role')
insert into Policy(ModuleId,code,name,description,type) values(1,'Read','Read a User','Role can read Users','Role')

insert into Policy(ModuleId,code,name,description,type) values(2,'Create','Create Role','Role can create a new Role','Role')
insert into Policy(ModuleId,code,name,description,type) values(2,'Edit','Edit Role','Role can edit existing Roles','Role')
insert into Policy(ModuleId,code,name,description,type) values(2,'Delete','Delete Role','Role can delete existing Roles','Role')
insert into Policy(ModuleId,code,name,description,type) values(2,'Read','Read a Role','Role can read Roles','Role')

insert into Policy(ModuleId,code,name,description,type) values(3,'Create','Create Employee Group','Role can create a new Employee Group','Role')
insert into Policy(ModuleId,code,name,description,type) values(3,'Edit','Edit Employee Group','Role can edit existing Employee Groups','Role')
insert into Policy(ModuleId,code,name,description,type) values(3,'Delete','Delete Employee Group','Role can delete existing Employee Groups','Role')
insert into Policy(ModuleId,code,name,description,type) values(3,'Read','Read an Employee Group','Role can read Employee Groups','Role')

insert into Policy(ModuleId,code,name,description,type) values(4,'Create','Create Active Directory Group','Role can create active directory group','Role')
insert into Policy(ModuleId,code,name,description,type) values(4,'Edit','Edit Active Directory Group','Role can edit active directory group','Role')
insert into Policy(ModuleId,code,name,description,type) values(4,'Delete','Delete Active Directory Group','Role can delete active directory group','Role')
insert into Policy(ModuleId,code,name,description,type) values(4,'Read','Read Active Directory Group','Role can create read directory group','Role')

insert into Policy(ModuleId,code,name,description,type) values(5,'Read','Read Preferences','Role can read Application''s Preferences','Role')
insert into Policy(ModuleId,code,name,description,type) values(5,'Edit','Edit Preferences','Role can edit existing Preferences','Role')

insert into Policy(ModuleId,code,name,description,type) values(6,'Update','Update Preference','Role can update Preferences functionality','Role')

insert into Policy(ModuleId,code,name,description,type) values(7,'Read','Read Attributes','Role can read all  Options Under Admin Attributes Menu','Role')
insert into Policy(ModuleId,code,name,description,type) values(7,'Edit','Edit Attributes','Role can edit all Options Under Admin Attributes Menu','Role')

insert into Policy(ModuleId,code,name,description,type) values(8,'Read','Read Application Setting','Role can read Application Settings','Role')
insert into Policy(ModuleId,code,name,description,type) values(8,'Edit','Edit Application Setting','Role can edit existing Application Settings','Role')

insert into Policy(ModuleId,code,name,description,type) values(9,'View','View Event Log','Role can view event log','Role')

insert into Policy(ModuleId,code,name,description,type) values(10,'Employee - Position','Search by Employee or position','Role can perform a search using the Employee or Position','Role')
insert into Policy(ModuleId,code,name,description,type) values(10,'Employee Group','Search by Employee Group','Role can perform a search using Employee Groups','Role')
insert into Policy(ModuleId,code,name,description,type) values(10,'Advanced Search','Search by Advanced','Role can perform an advanced search','Role')

insert into Policy(ModuleId,code,name,description,type) values(11,'OrgHierarchy','Print Organisation Hierarchy','Role can print out details of the Organisation Hierarchy','Role')


insert into Policy(ModuleId,code,name,description,type) values(12,'Add','Add Employee DataEntry','Role can add a new DataEntry Employee','Role')
insert into Policy(ModuleId,code,name,description,type) values(12,'Edit','Edit Employee DataEntry','Role can edit existing DataEntry Employee','Role')
insert into Policy(ModuleId,code,name,description,type) values(12,'Delete','Delete Employee DataEntry','Role can delete DataEntry Employee','Role')
insert into Policy(ModuleId,code,name,description,type) values(12,'Read','Read Employee DataEntry','Role can read DataEntry Employee','Role')


insert into Policy(ModuleId,code,name,description,type) values(13,'Add','Add Position DataEntry','Role can add a new DataEntry Position','Role')
insert into Policy(ModuleId,code,name,description,type) values(13,'Edit','Edit Position DataEntry','Role can edit existing DataEntry Position','Role')
insert into Policy(ModuleId,code,name,description,type) values(13,'Delete','Delete Position DataEntry','Role can delete DataEntry Position','Role')
insert into Policy(ModuleId,code,name,description,type) values(13,'Read','Read Position DataEntry','Role can read DataEntry Position','Role')

insert into Policy(ModuleId,code,name,description,type) values(14,'Edit','Edit Position Hierarchy ','Role can edit position hierarchy','Role')
insert into Policy(ModuleId,code,name,description,type) values(14,'Read','Read Position Hierarchy','Role can read position hierarchy','Role')

insert into Policy(ModuleId,code,name,description,type) values(15,'Edit','Edit Employee Position','Role can edit employees position','Role')
insert into Policy(ModuleId,code,name,description,type) values(15,'Read','Read an Employee Position','Role can read employees position','Role')

/*********************************** Role Policy( By Default Assigning All Polcies to Admin*****************************************************/

DECLARE @PolicyCount int
DECLARE @AdminRoleId int
DECLARE @PolicyId int
DECLARE @I int 
SET @PolicyCount =(select COUNT(id) from Policy )
SET @AdminRoleId =(select id from Role where code='Sys Admin')
SET @I =1

WHILE (@I<=@PolicyCount )
BEGIN
	SET @PolicyId=(select ID from Policy where ID=@I)
	insert into RolePolicy(policyid,roleid,granted ) values(@PolicyId,@AdminRoleId,'Y')
	SET @I =@I +1;
END

/*************************ROLE ATTRIBUTE ************************************************/
DECLARE @AttributeCount int
DECLARE @AttributeId int
SET @AttributeCount =(select COUNT(id) from Attribute )

SET @I=1
WHILE (@I<=@AttributeCount )
BEGIN
	SET @AttributeId=(select ID from Attribute  where ID=@I and (usereditable ='Y' or usereditable ='X' ))
	if(@AttributeId is not null)
		insert into RoleAttribute(attributeid ,roleid,granted ) values(@AttributeId,@AdminRoleId,'Y')
	SET @I =@I +1;
END
/*****************************************************************************************/
update Setting set value ='c:\inetpub\wwwroot\orgview\data\images\' where code ='PICFOLDER'
update Setting set value ='F:\orgview\' where code ='LOADDIR'
------------------------------------------------------------------------------------

------------------------------------------------------------------------
update Tab set Name='TAB1', Enable='N',TabOrder=1 where id=1
update Tab set Name='TAB2', Enable='N',TabOrder=2 where id=2
update Tab set Name='TAB3', Enable='N',TabOrder=3 where id=3
update Tab set Name='TAB4', Enable='N',TabOrder=4 where id=4
update Tab set Name='TAB5', Enable='N',TabOrder=5 where id=5
--------------------------------------------------------------------
update Attribute set tab =0
-------------------------------------------------------------------
update Attribute set ispersonal ='N', ismanagerial ='N' 
------------------------------------------------------------------------
update Entity set ordering=1 where id=2
update Entity set ordering=2 where id=4
update Entity set ordering=3 where id=3
update Entity set ordering=4 where id=1
update Entity set ordering=5 where id=7
update Entity set ordering=6 where id=9
----------------------------------------
update policymodules set ordering='1' where Id=1
update policymodules set ordering='2' where Id=4
update policymodules set ordering='3' where Id=2
update policymodules set ordering='4' where Id=7
update policymodules set ordering='5' where Id=3
update policymodules set ordering='6' where Id=5
update policymodules set ordering='7' where Id=6
update policymodules set ordering='8' where Id=8
update policymodules set ordering='9' where Id=9

IF NOT EXISTS (SELECT * FROM Setting WHERE [Code] LIKE 'DMFP') BEGIN
INSERT INTO Setting(code, name, description, value, datatype, usereditable, Ordering)
	VALUES('DMFP', 'Document Management folder path', 'Location documents are uploaded to', '~\Data\', 'string', 'N', 204)
END

IF NOT EXISTS (SELECT * FROM Setting WHERE [Code] LIKE 'DMSS') BEGIN
INSERT INTO Setting(code, name, description, value, datatype, usereditable, Ordering)
	VALUES('DMSS', 'Document Management system size cap', 'Max size in kb for the system', '51200', 'int', 'N', 205)
END

IF NOT EXISTS (SELECT * FROM Setting WHERE [Code] LIKE 'DMUS') BEGIN
INSERT INTO Setting(code, name, description, value, datatype, usereditable, Ordering)
	VALUES('DMUS', 'Document Management user size cap', 'Max size in kb for the system', '1024', 'int', 'N', 206)
END

IF NOT EXISTS (SELECT * FROM Setting WHERE [Code] LIKE 'DMFS') BEGIN
INSERT INTO Setting(code, name, description, value, datatype, usereditable, Ordering)
	VALUES('DMFS', 'Document Management file size cap', 'Max size in kb for any given file', '2048', 'int', 'N', 207)
END

IF NOT EXISTS (SELECT * FROM Attribute WHERE code LIKE 'documents-view') BEGIN
INSERT INTO Attribute(entityid, code, name, columnname, shortname, longname, datatype, [format], [contenttype], sortorder, justification, usereditable, ispersonal, ismanagerial, tab, dataentry, tabbasedsort)
	VALUES(2, 'documents-view', 'Documents View', 'documentsview', 'Documents View', 'Documents View', 'AnsiString', '', 'Value', 72, 'LEFT', 'X', 'Y', 'Y',0, 'N', 0)
END

IF NOT EXISTS (SELECT * FROM Attribute WHERE code LIKE 'documents-edit') BEGIN
INSERT INTO Attribute(entityid, code, name, columnname, shortname, longname, datatype, [format], [contenttype], sortorder, justification, usereditable, ispersonal, ismanagerial, tab, dataentry, tabbasedsort)
	VALUES(2, 'documents-edit', 'Documents Edit', 'documentsedit', 'Documents Edit', 'Documents Edit', 'AnsiString', '', 'Value', 75, 'LEFT', 'X', 'Y', 'Y',0, 'N', 0)
END

DECLARE @attEditID int;
DECLARE @attViewID int;

SELECT @attEditID = Id FROM Attribute WHERE code LIKE 'documents-edit'
SELECT @attViewID = Id FROM Attribute WHERE code LIKE 'documents-view'

IF NOT EXISTS (SELECT * FROM RoleAttribute WHERE roleid = 1 AND attributeid = @attEditID) BEGIN
	INSERT INTO RoleAttribute(roleid, attributeid, granted)
		VALUES(1, @attEditID, 'Y')
END

IF NOT EXISTS (SELECT * FROM RoleAttribute WHERE roleid = 1 AND attributeid = @attViewID) BEGIN
	INSERT INTO RoleAttribute(roleid, attributeid, granted)
		VALUES(1, @attViewID, 'Y')
END

IF NOT EXISTS (SELECT * FROM Attribute WHERE code LIKE 'competency-view') BEGIN
INSERT INTO Attribute(entityid, code, name, columnname, shortname, longname, datatype, [format], [contenttype], sortorder, justification, usereditable, ispersonal, ismanagerial, tab, dataentry, tabbasedsort)
	VALUES(2, 'competency-view', 'Competency View', 'competencyview', 'Competency View', 'Competency View', 'AnsiString', '', 'Value', 76, 'LEFT', 'X', 'Y', 'Y',0, 'N', 0)
END

IF NOT EXISTS (SELECT * FROM Attribute WHERE code LIKE 'competency-edit') BEGIN
INSERT INTO Attribute(entityid, code, name, columnname, shortname, longname, datatype, [format], [contenttype], sortorder, justification, usereditable, ispersonal, ismanagerial, tab, dataentry, tabbasedsort)
	VALUES(2, 'competency-edit', 'Competency Edit', 'competencyedit', 'Competency Edit', 'Competency Edit', 'AnsiString', '', 'Value', 76, 'LEFT', 'X', 'Y', 'Y',0, 'N', 0)
END

DECLARE @attEditCompID int;
DECLARE @attViewCompID int;

SELECT @attEditCompID = Id FROM Attribute WHERE code LIKE 'competency-edit';
SELECT @attViewCompID = Id FROM Attribute WHERE code LIKE 'competency-view';

IF NOT EXISTS (SELECT * FROM RoleAttribute WHERE roleid = 1 AND attributeid = @attEditCompID) BEGIN
	INSERT INTO RoleAttribute(roleid, attributeid, granted)
		VALUES(1, @attEditCompID, 'Y')
END

IF NOT EXISTS (SELECT * FROM RoleAttribute WHERE roleid = 1 AND attributeid = @attViewCompID) BEGIN
	INSERT INTO RoleAttribute(roleid, attributeid, granted)
		VALUES(1, @attViewCompID, 'Y')
END

IF NOT EXISTS (SELECT * FROM PolicyModules WHERE Modulename LIKE 'Competency Management') BEGIN
	INSERT INTO PolicyModules(Modulename, Sectioname, PageURL, Ordering)
		VALUES('Competency Management', 'Admin', '~/Admin/Competencies.aspx', 11)
END

DECLARE @moduleId int = 0;
SELECT @moduleId = Id FROM PolicyModules WHERE Modulename LIKE 'Competency Management';

IF NOT EXISTS (SELECT * FROM Policy WHERE name LIKE 'Create Competency') BEGIN
	INSERT INTO Policy(ModuleId, code, name, [description], [type])
		VALUES(@moduleId, 'Create', 'Create Competency', 'User can create a competency', 'Role');
	INSERT INTO RolePolicy(roleid, policyid, granted)
		VALUES(1, @@IDENTITY, 'Y');
END

IF NOT EXISTS (SELECT * FROM Policy WHERE name LIKE 'Edit Competency') BEGIN
	INSERT INTO Policy(ModuleId, code, name, [description], [type])
		VALUES(@moduleId, 'Edit', 'Edit Competency', 'User can edit a competency', 'Role');
	INSERT INTO RolePolicy(roleid, policyid, granted)
		VALUES(1, @@IDENTITY, 'Y');
END

IF NOT EXISTS (SELECT * FROM Policy WHERE name LIKE 'Delete Competency') BEGIN
	INSERT INTO Policy(ModuleId, code, name, [description], [type])
		VALUES(@moduleId, 'Delete', 'Delete Competency', 'User can delete a competency', 'Role');
	INSERT INTO RolePolicy(roleid, policyid, granted)
		VALUES(1, @@IDENTITY, 'Y');
END

IF NOT EXISTS (SELECT * FROM Policy WHERE name LIKE 'Read Competency') BEGIN
	INSERT INTO Policy(ModuleId, code, name, [description], [type])
		VALUES(@moduleId, 'Read', 'Read Competency', 'User can read a competency', 'Role');
	INSERT INTO RolePolicy(roleid, policyid, granted)
		VALUES(1, @@IDENTITY, 'Y');
END

SELECT @moduleId = Id FROM PolicyModules WHERE Modulename LIKE 'Search';

IF NOT EXISTS (SELECT * FROM Policy WHERE name LIKE 'Competency Search' AND ModuleId = @moduleId) BEGIN
	INSERT INTO Policy(ModuleId, code, name, [description], [type])
		VALUES(@moduleId, 'Competency Search', 'Competency Search', 'User can view competency search', 'Role');
END

DECLARE @polId int = 0;
SELECT @polId = Id FROM Policy WHERE name LIKE 'Competency Search' AND ModuleId = @moduleId

IF @polId > 0 BEGIN
	INSERT INTO RolePolicy(roleid, policyid, granted)
		VALUES(1, @polId, 'Y');
END

IF NOT EXISTS (SELECT * FROM PolicyModules WHERE Modulename LIKE 'File Upload') BEGIN
	INSERT INTO PolicyModules(Modulename, Sectioname, pageURL, Ordering)
		VALUES('File Upload', 'Admin', '~/Admin/LoadExcelFiles.aspx', 10)
END

SELECT @moduleId = Id FROM PolicyModules WHERE Modulename LIKE 'File Upload';

IF NOT EXISTS (SELECT * FROM Policy WHERE name LIKE 'Documents Upload' AND ModuleId = @moduleId) BEGIN
	INSERT INTO Policy(ModuleId, code, name, [description], [type])
		VALUES(@moduleId, 'Documents Upload', 'Documents Upload', 'User can upload documents', 'Role');
	INSERT INTO RolePolicy(roleid, policyid, granted)
		VALUES(1, @@IDENTITY, 'Y');
END

IF NOT EXISTS (SELECT * FROM Policy WHERE name LIKE 'Pictures Upload' AND ModuleId = @moduleId) BEGIN
	INSERT INTO Policy(ModuleId, code, name, [description], [type])
		VALUES(@moduleId, 'Pictures Upload', 'Pictures Upload', 'User can upload pictures', 'Role');
	INSERT INTO RolePolicy(roleid, policyid, granted)
		VALUES(1, @@IDENTITY, 'Y');
END

IF NOT EXISTS (SELECT * FROM Policy WHERE name LIKE 'Data Upload' AND ModuleId = @moduleId) BEGIN
	INSERT INTO Policy(ModuleId, code, name, [description], [type])
		VALUES(@moduleId, 'Data Upload', 'Data Upload', 'User can upload data', 'Role');
	INSERT INTO RolePolicy(roleid, policyid, granted)
		VALUES(1, @@IDENTITY, 'Y');
END

exec uspAddPreferenceDefaultValues

exec uspUpdateAttributeDefaultNames

END
-------------------------------------------------------

END
------------------------------------------------------------------

