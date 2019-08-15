/****** Object:  Procedure [dbo].[uspGetPositionProfile]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspGetPositionProfile](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM PositionProfile WHERE PositionID = @id;
END


