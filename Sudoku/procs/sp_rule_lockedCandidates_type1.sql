CREATE PROCEDURE [dbo].[sp_rule_lockedCandidates_type1]
	
AS
SET NOCOUNT ON;	
	--exec sp_display_candidates
/*
Rule locked candidates looks at each block and intersecting row or column
and says that where digits can only occur within that block within the intersect 
of either a particular row or column then the rest of the row or column 
falling outside the block in question cannot contain the digit and so it can 
be eliminated as a possible candidate in the solution
*/

DECLARE @counterMin int, @counterMax int, @cellID int, @digit int;

--organises freq of digits by either row, col or block
--for a given occurence
--freq table has those digits which occur with a frequency of 2-3 
--there is repetition in the table where selections are arranged
--by row, col and block. 
--For each record in the table there is also xref row col block
--together with an inter block sub row and sub column 
DECLARE @freq table(
	cellID int,
	digit int,
	f_row int,
	f_col int,
	f_block int,
	f_xrefRow int,
	f_xrefCol int,
	f_xrefBlock int,
	f_subRow int,
	f_subCol int
)

--used to store those digits that appear within a single sub row or column
--within a block
DECLARE @possLocked table
( 
	pl_block int,
	pl_digit int,
	pl_rowcol int,
	pl_sub_rowcol int
)

--use to store cellID and digits that can be eliminated. These lay in the 
--in a row/col that intersects with a given block where the region of
--the row lays beyond the block, ie 'except region'. These digits 
--can be eliminated. (The digits also appear in the region intersecting the
--block and represent the only occurences of those digits in the block)
DECLARE @digitsToUpdate table
(
	d_cellID int,
	d_digit int,
	d_rowcol int,
	d_block int,
	d_id int
)

delete @freq 

--fill the @freq table using the sp_get_digitsThatOccur_byFreqRange which defaults
--to between 2 and 3 (incl) digit freq
insert into @freq (cellID,digit,f_row,f_col,f_block, f_xrefRow, f_xrefCol, f_xrefBlock, f_subRow, f_subCol)
exec [sp_get_digitsThatOccur_byFreqRange] ;

--intersecting rows


----DEBUG
--select '---ROWS-----'
----end DEBUG

delete @possLocked
delete @digitsToUpdate


--This query selects just the section of the freq table where the 
--freq table is filtered by block using f.f_block<>0.
--count(distinct f.f_subRow)=1 filters out those digits which occur 
--2 or 3 times within a block but on different sub rows/cols 
--within the block. 
--We only want the sub row/col count to be 1 which is the case where
--all digits are contained in the same sub row/col
--Min xrefRow selects the row into the result (used min but as there is 
--only one row other aggregates would also work)
--The result is inserted into  @possLocked temp table
insert into @possLocked (pl_block,pl_digit,pl_rowcol,pl_sub_rowcol)
	select f_block, f.digit, min(f.f_xrefRow) as xrow, min(distinct f.f_subRow) as subRow 
	from @freq as f where f.f_block<>0 
		group by  f_block, f.digit
		having count(distinct f.f_subRow)=1
		order by f_block

----DEBUG
--select pl.pl_block, pl.pl_digit, pl.pl_rowcol from @possLocked as pl
--order by pl_block
----end DEBUG


--look at the 'except' region of the row falling outside the block
--and where the digit occurs get the corresponding cellid and digit
--these digits can be cleared. Use row number so the query can be
--enumerated 
insert into @digitsToUpdate (d_cellID,d_digit,d_rowcol,d_block,d_id)
	select cd.cellID, cd.digit, l.s_row, l.s_block, row_number() over (order by cd.cellID) as rn
	from  candidate_digits as cd 
		join lookupRCB as l on cd.cellID=l.cellID
		join @possLocked as p on l.s_row = p.pl_rowcol
		where cd.value=1 and l.s_block<>p.pl_block and cd.digit=p.pl_digit
		order by l.s_row
----DEBUG
--select * from @digitsToUpdate
----end DEBUG

set @counterMin=1;
set @counterMax=(select count(*) from @digitsToUpdate);

while @counterMin<=@counterMax
if(@counterMax>0)
	begin
		begin
			set @cellID = (select d.d_cellID from @digitsToUpdate as d where d.d_id=@counterMin)
			set @digit = (select d.d_digit from @digitsToUpdate as d where d.d_id=@counterMin)
			----DEBUG
			--select 'to update: '
			--select @cellID, @digit
			----end DEBUG

			exec sp_updateDigit_ClearCandidate_byCellID @cellID, @digit
			set @counterMin=@counterMin+1;
		end
	end



--intersecting cols
--same as above but acts on the columns

----DEBUG
--select '---COLS-----'
----end DEBUG
delete @possLocked
delete @digitsToUpdate
 
insert into @possLocked (pl_block,pl_digit,pl_rowcol,pl_sub_rowcol) 
	select f_block, f.digit, min(f.f_xrefCol) as xcol, min(distinct f.f_subCol) as subCol 
		from @freq as f where f.f_block<>0 
		group by  f_block, f.digit
		having count(distinct f.f_subCol)=1
		order by f_block

----DEBUG
--select pl.pl_block, pl.pl_digit, pl.pl_rowcol from @possLocked as pl 
--order by pl_block
----end DEBUG

insert into @digitsToUpdate (d_cellID,d_digit,d_rowcol,d_block,d_id)
	select cd.cellID, cd.digit, l.s_col, l.s_block, row_number() over (order by cd.cellID) as rn 
	from  candidate_digits as cd 
		join lookupRCB as l on cd.cellID=l.cellID
		join @possLocked as p on l.s_col = p.pl_rowcol
		where cd.value=1 and l.s_block<>p.pl_block and cd.digit=p.pl_digit
		order by l.s_col

----DEBUG
--select * from @digitsToUpdate
----end DEBUG

set @counterMin=1;
set @counterMax=(select count(*) from @digitsToUpdate);

if(@counterMax=0)RETURN -1
else
	begin
		while @counterMin<=@counterMax
		begin
			set @cellID = (select d.d_cellID from @digitsToUpdate as d where d.d_id=@counterMin)
			set @digit = (select d.d_digit from @digitsToUpdate as d where d.d_id=@counterMin)
			----DEBUG
			--select 'to update: '
			--select @cellID, @digit
			----end DEBUG
			exec sp_updateDigit_ClearCandidate_byCellID @cellID, @digit
			set @counterMin=@counterMin+1;
		end
	end
RETURN @counterMax

