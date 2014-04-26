use Sudoku
select * from dbo.constants
exec sp_initialiseConstants
exec sp_initialise
delete constants
select count(*) from dbo.constants

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
	join dbo.lookupRCB as l on
	c.id = l.cellID
GROUP BY s_row

exec [sp_display_Start]


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



select *
From dbo.cells as ce 
	inner join dbo.lookupRCB as l on
	ce.id = l.cellID
	inner join dbo.candidates as ca on
	ce.id = ca.cellID


exec [sp_display_Start];
exec [sp_display_NumberOfDigitsToFind]
GO

DECLARE @tBits table
(
	id int,
	digit bit
)

insert into @tBits (id,digit) values (1,0);
insert into @tBits (id,digit) values (2,0);
insert into @tBits (id,digit) values (3,1);
insert into @tBits (id,digit) values (4,1);
insert into @tBits (id,digit) values (5,0);

select * from @tBits;
select count(*) from @tBits where digit<>0;