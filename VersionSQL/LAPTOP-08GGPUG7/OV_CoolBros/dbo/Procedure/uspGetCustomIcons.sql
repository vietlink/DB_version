/****** Object:  Procedure [dbo].[uspGetCustomIcons]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetCustomIcons](@CustomIcon varchar(100),@IconId varchar(10))
AS
BEGIN

select AP.id,preferenceid,[type],value,P.code  from ApplicationPreference AP INNER JOIN Preference P on P.id =AP.preferenceid  where AP.preferenceid in (select id from Preference where code like ''+@CustomIcon+'%')
UNION 
select AP.id,preferenceid,[type],value,P.code  from ApplicationPreference AP INNER JOIN Preference P on P.id =AP.preferenceid  where preferenceid in (select id from Preference where code like 'customnavigate'+@IconId+'url')

END
