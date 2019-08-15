/****** Object:  Procedure [dbo].[uspUpdateCompetencyGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateCompetencyGroup](@id int, @typeid int, @code varchar(50), @description varchar(500), @enabled char(1))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @retVal int = -1;
    EXEC @retVal = uspCheckCompetencyTypeContainsGroup @typeid, @description, @code, @id;
    IF @retVal = 0 BEGIN
		UPDATE 
			CompetencyGroups
		SET
			TypeId = @typeid,
			[Description] = @description,
			Code = @code,
			[Enabled] = @enabled
		WHERE
			Id = @id
		RETURN 0;		
    END
    ELSE IF @retVal = 1 BEGIN
		RETURN -1;
	END
	ELSE IF @retVal = 2 BEGIN
		RETURN -2;
	END
END

