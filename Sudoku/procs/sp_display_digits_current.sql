CREATE PROCEDURE [dbo].[sp_display_digits_current]
	
AS

select 'board showing digits current'
Select s_row as 'r/c',
	MAX(CASE WHEN s_col= 1 THEN digit_current END) AS a,
	MAX(CASE WHEN s_col= 2 THEN digit_current END) AS b,
	MAX(CASE WHEN s_col= 3 THEN digit_current END) AS c,
	MAX(CASE WHEN s_col= 4 THEN digit_current END) AS d,
	MAX(CASE WHEN s_col= 5 THEN digit_current END) AS e,
	MAX(CASE WHEN s_col= 6 THEN digit_current END) AS f,
	MAX(CASE WHEN s_col= 7 THEN digit_current END) AS g,
	MAX(CASE WHEN s_col= 8 THEN digit_current END) AS h,
	MAX(CASE WHEN s_col= 9 THEN digit_current END) AS i
From dbo.cells as ce 
	inner join dbo.lookupRCB as l on
	ce.id = l.cellID
	inner join dbo.candidates as ca on
	ce.id = ca.cellID

GROUP BY s_row
RETURN 0
