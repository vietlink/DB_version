/****** Object:  Procedure [dbo].[uspGetCustomisedFields]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetCustomisedFields]
AS
BEGIN

select e.name +'.'+a.name  as Name,a.id as Id from Attribute A inner join Entity E on E.id =A.entityid  where A.code='displayname' and E.name ='Employee Detail'
UNION
select e.name +'.'+a.name  as Name,a.id as Id from Attribute A inner join Entity E on E.id =A.entityid  where A.code='postitle' and E.name ='Position Detail'
UNION 

select e.name +'.'+a.name  as Name,a.id as Id from Attribute A inner join Entity E on E.Id=A.entityid 
where A.id in (
select value as AttributeId  from  ApplicationPreference 

where preferenceid in(

select id from Preference where code like 'customfield%id'))

END
