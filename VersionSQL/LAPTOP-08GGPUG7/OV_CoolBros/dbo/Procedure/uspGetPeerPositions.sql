/****** Object:  Procedure [dbo].[uspGetPeerPositions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPeerPositions](@positionId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @parentPosId int = 0;
	SELECT @parentPosId = parentid FROM Position WHERE id = @positionId;

	SELECT * FROM Position WHERE parentid = @parentPosId AND IsDeleted = 0 AND IsUnassigned = 0
END


