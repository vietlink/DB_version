/****** Object:  Procedure [dbo].[uspGetPreferenceCustomFieldDetails]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetPreferenceCustomFieldDetails](@CustomField varchar(50))
AS
BEGIN
select AP.id  as AppPrefernceId,Ap.Preferenceid,Ap.type,Ap.Value,
(select value from ApplicationPreference  where preferenceid =(select id from Preference where code = ''+ @CustomField+'id')) as AttributeId ,
(select id  from entity 
					   where tablename =(
											select Substring(isnull(value,0),0,CHARINDEX('.',value))
					    from ApplicationPreference AP where AP.preferenceid in(select id from Preference where code = ''+ @CustomField+''))) as EntityId
from ApplicationPreference AP where AP.preferenceid in(select id from Preference where code = ''+ @CustomField+'') 
END
