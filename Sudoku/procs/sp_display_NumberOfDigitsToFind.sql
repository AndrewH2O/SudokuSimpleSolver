﻿CREATE PROCEDURE [dbo].[sp_display_NumberOfDigitsToFind]
AS
		
select 'board showing number of digits to find'
Select s_row as 'r/c',
	MAX(CASE WHEN s_col= 1 THEN numberPossibles END) AS a,
	MAX(CASE WHEN s_col= 2 THEN numberPossibles END) AS b,
	MAX(CASE WHEN s_col= 3 THEN numberPossibles END) AS c,
	MAX(CASE WHEN s_col= 4 THEN numberPossibles END) AS d,
	MAX(CASE WHEN s_col= 5 THEN numberPossibles END) AS e,
	MAX(CASE WHEN s_col= 6 THEN numberPossibles END) AS f,
	MAX(CASE WHEN s_col= 7 THEN numberPossibles END) AS g,
	MAX(CASE WHEN s_col= 8 THEN numberPossibles END) AS h,
	MAX(CASE WHEN s_col= 9 THEN numberPossibles END) AS i
From dbo.cells as ce 
	inner join dbo.lookupRCB as l on
	ce.id = l.cellID
	inner join dbo.candidates as ca on
	ce.id = ca.cellID

GROUP BY s_row
RETURN 0

