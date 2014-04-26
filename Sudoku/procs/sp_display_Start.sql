CREATE PROCEDURE [dbo].[sp_display_Start]
AS
select 'board showing start'
Select s_row as 'r/c',
	MAX(CASE WHEN s_col= 1 THEN start END) AS a,
	MAX(CASE WHEN s_col= 2 THEN start END) AS b,
	MAX(CASE WHEN s_col= 3 THEN start END) AS c,
	MAX(CASE WHEN s_col= 4 THEN start END) AS d,
	MAX(CASE WHEN s_col= 5 THEN start END) AS e,
	MAX(CASE WHEN s_col= 6 THEN start END) AS f,
	MAX(CASE WHEN s_col= 7 THEN start END) AS g,
	MAX(CASE WHEN s_col= 8 THEN start END) AS h,
	MAX(CASE WHEN s_col= 9 THEN start END) AS i
From dbo.cells as c 
	inner join dbo.lookupRCB as l on
	c.id = l.cellID
GROUP BY s_row
RETURN 0
