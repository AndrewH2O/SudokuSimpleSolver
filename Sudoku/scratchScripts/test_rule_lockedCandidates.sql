Use Sudoku

DECLARE @number_found int;
DECLARE @cellID int, @digit int;
DECLARE @occurence int;

set @number_found=0;
set @occurence=2;

DECLARE @freq table(
	cellID int,
	digit int,
	f_row int,
	f_col int,
	f_block int
)

delete @freq 

insert into @freq (cellID,digit,f_row,f_col,f_block)
exec [sp_get_freqDigit_byOccurence] @occurence;

set @number_found=(select count(*) from @freq);
--select sub rows/cols within block
DECLARE @lookupSubRowsCols table (
	int cellID,
	int sub_number,
	int s_block,
	int s_subRow,
	int s_subCol
)

delete @lookupSubRowsCols

select l.cellID, l.s_block, l.s_col, l.s_row from lookupRCB as l
where l.s_block=1 


/*
--select those cases where digit freq of 2 occurs
--at intersection of row and block or col and block
--(the digit may occur elsewhere in row/col but freq
-- in block is key - this query rules out where digit 
--occurs more than once in the block but in different 
--rows/cols)
select * from @freq as f1 join @freq as f2
on f1.cellID=f2.cellID
	where f2.digit=2 and f1.f_block=1 and f2.f_row=1
*/ 

--next need to see if we can eliminate any further digits
--falling inside selected row or col as these will be 
--eliminated
 /*
DECLARE @block_counter int
DECLARE @digit_counter int
set @block_counter=1;
set @digit_counter=1;

while @block_counter<=9
begin
	while @digit_counter<=9
	begin
		select * from candidate_digits as cd 
			join lookupRCB as l 
			on cd.cellID=l.cellID 
				where cd.digit=@digit_counter and cd.value=1 and 
				l.s_row in (select l.s_row from lookupRCB as l where l.s_block=@block_counter)
		set @digit_counter=@digit_counter+1
	end
	set @block_counter=@block_counter+1
end
*/