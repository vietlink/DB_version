/****** Object:  Procedure [dbo].[uspUpdateNonAttributePermissions]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateNonAttributePermissions](
@AttributeId int,
@EntityId int,
@IsPersdonal varchar(10),
@IsManagerial varchar(10))

AS
BEGIN

UPDATE Attribute SET
				 ispersonal =@IsPersdonal,
				 ismanagerial =@IsManagerial
WHERE entityid =@EntityId and id=@AttributeId 

END

