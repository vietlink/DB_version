/****** Object:  Procedure [dbo].[uspSetSecondaryPositions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetSecondaryPositions](@empId int, @isFromEngine int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @today datetime = DATEADD(d,0,DATEDIFF(d,0,GETDATE()));

	DECLARE @positionid int;
	DECLARE @startdate datetime;
	DECLARE @enddate datetime;
	DECLARE @fte decimal(18, 8);
	DECLARE @managerial varchar(1);
	DECLARE @exclfromcount varchar(1);
	DECLARE @managerid int;

	DECLARE @vacantId int = 0;
	SELECT @vacantId = id FROM employee WHERE identifier = 'Vacant';

	DECLARE @updateCount bit = 0;

    UPDATE 
		EmployeePosition
	SET
		IsDeleted = 1
	WHERE
		primaryposition = 'N' AND
		employeeid = @empId

	DECLARE secondaryCursor CURSOR  
    FOR 
		SELECT
			positionid, startdate, enddate, fte, managerial, ExclFromSubordCount, ManagerID
		FROM
			EmployeePositionHistory
		WHERE
			employeeid = @empid AND primaryposition = 'N'
		ORDER BY StartDate ASC
			--AND
			--((@today BETWEEN startdate AND isnull(enddate, '01-01-9999'))
			--OR
			--(startdate = @today OR enddate = @today))

	OPEN secondaryCursor  
  
	FETCH NEXT FROM 
		secondaryCursor   
	INTO
		@positionid, @startdate, @enddate, @fte, @managerial, @exclfromcount, @managerid

	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		DECLARE @epId int = 0;
		SELECT @epId = id FROM EmployeePosition WHERE employeeid = @empId AND positionid = @positionid

		IF ISNULL(@epId, 0) > 0 BEGIN
			--update
			UPDATE
				EmployeePosition
			SET
				IsDeleted = 0,
				primaryposition = 'N',
				startdate = @startdate,
				enddate = @enddate,
				fte = @fte,
				managerial = @managerial,
				ExclFromSubordCount = @exclfromcount,
				managerid = @managerid
			WHERE
				employeeid = @empId AND positionid = @positionid

			IF @empId <> @vacantId BEGIN
				UPDATE EmployeePosition SET IsDeleted = 1 WHERE positionid = @positionid AND employeeid = @vacantId;
				UPDATE EmployeePositionInfo SET IsVisible = 0 WHERE positionid = @positionid AND employeeid = @vacantId;
			END
		END
		ELSE BEGIN
			--insert new
			SET @updateCount = 1;
			INSERT INTO
				EmployeePosition(employeeid, positionid,
				primaryposition, startdate, enddate, fte, managerial, ExclFromSubordCount, managerid)
			VALUES(@empId, @positionid, 'N', @startdate, @enddate, @fte, @managerial, @exclfromcount, @managerid)
			SET @epId = @@IDENTITY;

			IF @empId <> @vacantId BEGIN
				UPDATE EmployeePosition SET IsDeleted = 1 WHERE positionid = @positionid AND employeeid = @vacantId;
				UPDATE EmployeePositionInfo SET IsVisible = 0 WHERE positionid = @positionid AND employeeid = @vacantId;
			END
		END
		
		exec dbo.uspCreateEPIRecord @epId, @empId, @positionid
		exec dbo.uspRunUpdatePreference @epId, @empId, @positionid

		FETCH NEXT FROM 
			secondaryCursor   
		INTO
			@positionid, @startdate, @enddate, @fte, @managerial, @exclfromcount, @managerid
	END

	CLOSE secondaryCursor;
	DEALLOCATE secondaryCursor

	IF((SELECT COUNT(id) FROM EmployeePosition WHERE primaryposition = 'N' AND employeeid = @empId AND IsDeleted = 0 AND (startdate > @today OR isnull(enddate, @today) < @today)) > 0) BEGIN
		SET @updateCount = 1;
		UPDATE 
			EmployeePosition
		SET
			IsDeleted = 1
		WHERE
			primaryposition = 'N' AND
			employeeid = @empId AND
			(startdate > @today OR isnull(enddate, @today) < @today)

		UPDATE
			EmployeePositionInfo
		SET
			IsVisible = 0
		WHERE
			ID IN
			(
				SELECT
					ID
				FROM
					EmployeePosition
				WHERE
					primaryposition = 'N' AND
					employeeid = @empId AND IsDeleted = 1
			)
	END
	IF @isFromEngine = 0 AND @updateCount = 1 BEGIN
		exec dbo.uspBuildPositionGrouplessHierarchy;
		exec dbo.uspUpdateAllCounts;
		exec dbo.uspSetEmptyParentEmpPos;
	END
END


