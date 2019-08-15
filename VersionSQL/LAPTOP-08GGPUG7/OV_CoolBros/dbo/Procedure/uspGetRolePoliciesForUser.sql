/****** Object:  Procedure [dbo].[uspGetRolePoliciesForUser]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetRolePoliciesForUser](@UserId int)  
AS  
BEGIN  
  
select distinct P.id as PolicyId,P.code,P.name,P.description from RolePolicy RP inner join Policy P on P.id =RP.policyid inner join Role R on R.id=RP.roleid   
where roleid in (select roleid from RoleUser where userid =@UserId)  
END
