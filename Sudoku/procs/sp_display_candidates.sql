CREATE PROCEDURE [dbo].[sp_display_candidates]
	
	
AS
	select 'board showing digits current'
Select s_row as 'r/c',
	MAX(CASE WHEN s_col= 1 THEN asStr END) AS a,
	MAX(CASE WHEN s_col= 2 THEN asStr END) AS b,
	MAX(CASE WHEN s_col= 3 THEN asStr END) AS c,
	MAX(CASE WHEN s_col= 4 THEN asStr END) AS d,
	MAX(CASE WHEN s_col= 5 THEN asStr END) AS e,
	MAX(CASE WHEN s_col= 6 THEN asStr END) AS f,
	MAX(CASE WHEN s_col= 7 THEN asStr END) AS g,
	MAX(CASE WHEN s_col= 8 THEN asStr END) AS h,
	MAX(CASE WHEN s_col= 9 THEN asStr END) AS i
From dbo.cells as ce 
	inner join dbo.lookupRCB as l on
	ce.id = l.cellID
	inner join dbo.candidates as ca on
	ce.id = ca.cellID

GROUP BY s_row

RETURN 0
