/****** Object:  Procedure [dbo].[uspUpdatePositionProfile]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspUpdatePositionProfile](@id int, @profile varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF EXISTS(SELECT id FROM PositionProfile WHERE PositionID = @id) BEGIN
		UPDATE PositionProfile SET [Profile] = @profile WHERE PositionID = @id;
	END
	ELSE
		INSERT INTO PositionProfile(PositionID, [Profile]) VALUES(@id, @profile)
END


