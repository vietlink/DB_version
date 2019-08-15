/****** Object:  Procedure [dbo].[uspGetAllCustomIconsWithType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAllCustomIconsWithType]  
as  
begin  
  
select P.Id,P.code,AP.Type,AP.value,SUBSTRING (ap.value,0,charindex('.',ap.value)) as Tablename,SUBSTRING (ap.value,charindex('.',ap.value)+1,(len(ap.value)-charindex('.',ap.value))) as Columnname from Preference P  
inner join ApplicationPreference AP on AP.PreferenceId=P.Id  
where P.code like 'customnavigate%'   
  
end
