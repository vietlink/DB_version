/****** Object:  Procedure [dbo].[uspUpdateTabNames]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdateTabNames](@TabId int,@TabName varchar(100),@Enable varchar(1))
AS
BEGIN

UPDATE Tab set Name =@TabName,Enable =@Enable where Id=@TabId 
END
