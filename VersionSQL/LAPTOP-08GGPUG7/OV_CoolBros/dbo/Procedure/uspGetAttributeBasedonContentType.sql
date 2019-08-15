/****** Object:  Procedure [dbo].[uspGetAttributeBasedonContentType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetAttributeBasedonContentType](@ContentType varchar(50))
AS
BEGIN

select distinct E.id,E.name  from Entity E inner join Attribute A on E.id =A.entityid 
WHERE A.contenttype =@ContentType and A.usereditable='Y'

END
