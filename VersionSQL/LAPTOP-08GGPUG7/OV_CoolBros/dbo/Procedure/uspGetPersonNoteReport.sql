/****** Object:  Procedure [dbo].[uspGetPersonNoteReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPersonNoteReport] 
	-- Add the parameters for the stored procedure here
	@empID int, @fromDate Datetime, @toDate Datetime, @noteTypeList varchar(max),  @canView int, @groupBy varchar(max), @sortBy varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @NoteTypeTable TABLE(notetype varchar(30));
	
	IF CHARINDEX(',', @noteTypeList, 0) > 0 BEGIN
		INSERT INTO @NoteTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@noteTypeList, ',');	
    END
    ELSE IF LEN(@noteTypeList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @NoteTypeTable(notetype) VALUES(@noteTypeList);	
    END
		
    -- Insert statements for procedure here
SELECT * FROM (
	SELECT 
	n.CreatedDatetime AS CreatedDate,
	ec.displayname AS CreatedBy,
	nt.Name AS NoteType,
	n.pagetype AS Source,
	n.Subject AS Subject,
	n.CanEmpView AS EmpView,
	n.UpdatedDatetime AS LastUpdate,
	eu.displayname AS UpdatedBy,
	n.Body AS Body
	FROM Notes n
	INNER JOIN NoteTypes nt ON n.NoteTypeID= nt.ID
	INNER JOIN NotesEmployeeRelations ner ON n.id= ner.noteid
	--INNER JOIN dbo.[User] e ON n.EmployeeUserID= e.id
	--INNER JOIN Employee emp ON ner.EmployeeID= emp.id
	INNER JOIN dbo.[User] ec ON n.CreatedUserID= ec.id
	INNER JOIN dbo.[User] eu ON n.UpdatedUserID= eu.ID	
	WHERE (n.CreatedDateTime BETWEEN @fromDate AND @toDate)
	AND ((SELECT COUNT(*) FROM @NoteTypeTable) = 0 OR nt.Name IN (SELECT * FROM @NoteTypeTable))
	AND ner.EmployeeID	= @empID
	AND ((@canView=0 AND n.CanEmpView=1) OR (@canView=1))
	--AND ((lower(n.PageType)='employee') OR (lower(n.pagetype)='position'))
UNION
	SELECT 
	n.CreatedDatetime AS CreatedDate,
	ec.displayname AS CreatedBy,
	nt.Name AS NoteType,
	n.pagetype AS Source,
	n.Subject AS Subject,
	n.CanEmpView AS EmpView,
	n.UpdatedDatetime AS LastUpdate,
	eu.displayname AS UpdatedBy,
	n.Body AS Body
	FROM Notes n
	INNER JOIN NoteTypes nt ON n.NoteTypeID= nt.ID
	INNER JOIN NotesPositionRelations npr ON n.ID= npr.NoteID
	INNER JOIN EmployeePosition ep ON npr.PositionID= ep.positionid	
	--INNER JOIN NotesEmployeeRelations ner ON n.id= ner.noteid
	--INNER JOIN dbo.[User] e ON n.EmployeeUserID= e.id
	--INNER JOIN Employee emp ON ner.EmployeeID= emp.id
	INNER JOIN dbo.[User] ec ON n.CreatedUserID= ec.id
	INNER JOIN dbo.[User] eu ON n.UpdatedUserID= eu.ID	
	WHERE (n.CreatedDateTime BETWEEN @fromDate AND @toDate)
	AND ((SELECT COUNT(*) FROM @NoteTypeTable) = 0 OR nt.Name IN (SELECT * FROM @NoteTypeTable))
	AND ep.EmployeeID	= @empID
	AND ep.primaryposition='Y' AND ep.IsDeleted=0
	AND ((@canView=0 AND n.CanEmpView=1) OR (@canView=1))
UNION
	SELECT 
	n.CreatedDatetime AS CreatedDate,
	ec.displayname AS CreatedBy,
	nt.Name AS NoteType,
	cg.description AS Source,
	n.Subject AS Subject,
	n.CanEmpView AS EmpView,
	n.UpdatedDatetime AS LastUpdate,
	eu.displayname AS UpdatedBy,
	n.Body AS Body
	FROM Notes n
	INNER JOIN NoteTypes nt ON n.NoteTypeID= nt.ID	
	INNER JOIN NotesCompetencyRelations ncr ON n.ID= ncr.NoteID
	INNER JOIN EmployeeCompetencyList ecl ON ncr.CompetencyID = ecl.id
	INNER JOIN CompetencyList cl ON ecl.CompetencyListId= cl.Id
	INNER JOIN CompetencyGroups cg ON cl.CompetencyGroupID= cg.ID
	--INNER JOIN dbo.[User] e ON n.EmployeeUserID= e.id
	--INNER JOIN Employee emp ON e.accountname= emp.accountname
	INNER JOIN dbo.[User] ec ON n.CreatedUserID= ec.id
	INNER JOIN dbo.[User] eu ON n.UpdatedUserID= eu.ID	
	WHERE (n.CreatedDateTime BETWEEN @fromDate AND @toDate)
	AND ((SELECT COUNT(*) FROM @NoteTypeTable) = 0 OR nt.Name IN (SELECT * FROM @NoteTypeTable))
	AND ecl.Employeeid= @empID
	AND ((@canView=0 AND n.CanEmpView=1) OR (@canView=1))
	--AND ((lower(n.PageType)='competency') OR (lower(n.pagetype)='compliance'))
	) AS result
	ORDER BY	
		
		CASE WHEN @groupBy='createdBy' THEN result.CreatedBy END,
		CASE WHEN @groupBy='noteType' THEN result.NoteType END,
		CASE WHEN @groupBy='updatedBy' THEN result.UpdatedBy END,
		CASE WHEN @groupBy='source' THEN result.Source END,		
		CASE WHEN (@sortBy='createdateasc') THEN result.CreatedDate END ,
		CASE WHEN (@sortBy='createdatedesc') THEN result.CreatedDate END DESC,
		CASE WHEN (@sortBy='updatedateasc') THEN result.LastUpdate END, 
		CASE WHEN (@sortBy='updatedatedesc') THEN result.LastUpdate END DESC,
		CASE WHEN (@sortBy='createdby') THEN result.CreatedBy END,
		CASE WHEN (@sortBy='notetype') THEN result.NoteType END,
		CASE WHEN (@sortBy='source') THEN result.Source END,
		CASE WHEN (@sortBy='updateby') THEN result.UpdatedBy END,			
		CASE WHEN @sortBy='subject' THEN result.Subject END
		
END

