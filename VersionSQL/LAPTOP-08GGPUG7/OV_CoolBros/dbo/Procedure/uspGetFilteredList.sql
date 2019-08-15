/****** Object:  Procedure [dbo].[uspGetFilteredList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFilteredList](@filterType int, @filter varchar(200))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF @filterType = 2 BEGIN -- Division
		SELECT DISTINCT case when isnull(OrgUnit2, '') = '' then '(Blank)' else OrgUnit2 end as item, 0 as id FROM Position WHERE IsDeleted = 0 AND OrgUnit2 LIKE '%' + @filter + '%'
	END

	IF @filterType = 3 BEGIN -- Department
		SELECT DISTINCT case when isnull(OrgUnit3, '') = '' then '(Blank)' else OrgUnit3 end as item, 0 as id FROM Position WHERE IsDeleted = 0 AND OrgUnit3 LIKE '%' + @filter + '%'
	END

	IF @filterType = 4 BEGIN -- Location
		SELECT DISTINCT case when isnull(Location, '') = '' then '(Blank)' else Location end as item, 0 as id FROM Employee WHERE IsDeleted = 0 AND Location LIKE '%' + @filter + '%'
	END

	IF @filterType = 5 BEGIN -- Position
		SELECT DISTINCT case when isnull(Title, '') = '' then '(Blank)' else Title end as item, id FROM Position WHERE IsDeleted = 0 AND title LIKE '%' + @filter + '%' ORDER BY item
	END

	IF @filterType = 6 BEGIN -- Status
		SELECT DISTINCT case when isnull([Description], '') = '' then '(Blank)' else [Description] end as item, 0 as id FROM [status] WHERE Code <> 'D' AND [Description] LIKE '%' + @filter + '%';
	END

	IF @filterType = 7 BEGIN -- Type
		SELECT DISTINCT case when isnull([Type], '') = '' then '(Blank)' else [Type] end as item, 0 as id FROM Employee WHERE IsDeleted = 0 AND [Type] LIKE '%' + @filter + '%';
	END
	IF @filterType = 8 BEGIN -- Note type
		SELECT DISTINCT case when isnull([Name], '') = '' then '(Blank)' else [Name] end as item, 0 as id FROM NoteTypes WHERE IsDeleted = 0 AND [Name] LIKE '%' + @filter + '%';
	END
	IF @filterType = 9 BEGIN -- Page type
		SELECT DISTINCT case when isnull(PageType, '') = '' then '(Blank)' else PageType end as item, 0 as id FROM Notes WHERE PageType LIKE '%' + @filter + '%';
	END
	IF @filterType = 10 BEGIN -- Cost centre
		SELECT DISTINCT case when isnull(Description, '') = '' then '(Blank)' else Description end as item, 0 as id FROM CostCentres WHERE Description LIKE '%' + @filter + '%' AND IsExpenseCostCentre=1;
	END
	IF @filterType = 11 BEGIN -- Expense Code
		SELECT DISTINCT case when isnull(Description, '') = '' then '(Blank)' else Description end as item, 0 as id FROM ExpenseCode WHERE Description LIKE '%' + @filter + '%';
	END
	IF @filterType = 12 BEGIN -- Leave Type
		SELECT DISTINCT case when isnull(Description, '') = '' then '(Blank)' else ReportDescription end as item, 0 as id FROM LeaveType WHERE ReportDescription LIKE '%' + @filter + '%' and Enabled=1;
	END
END
