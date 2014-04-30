use Sudoku

DECLARE @freq table(
	cellID int,
	digit int,
	f_row int,
	f_col int,
	f_block int
)

delete @freq

DECLARE @index int, @occurence int, @counter int;
set @index=2
set @occurence=2
set @counter=1;

while @counter<=9
begin

set @index=@counter
	--row
	insert into @freq (cellID, digit, f_row, f_col, f_block)
	select cd.cellID, cd.digit, l.s_row, 0, 0 
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_row=@index and cd.value=1 and cd.digit in 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_row=@index and cd.value=1
					group by cd.digit
					having count(*) = @occurence)
	--col
	insert into @freq (cellID, digit, f_row, f_col, f_block)
	select cd.cellID, cd.digit, 0, l.s_col, 0
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_col=@index and cd.value=1 and cd.digit in 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_col=@index and cd.value=1
					group by cd.digit
					having count(*) = @occurence)

	--block
	insert into @freq (cellID, digit, f_row, f_col, f_block)
	select cd.cellID, cd.digit, 0, 0, l.s_block
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_block=@index and cd.value=1 and cd.digit in 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_block=@index and cd.value=1
					group by cd.digit
					having count(*) = @occurence)

	set @counter = @counter+1
end

select digit, cellID,  f_row, f_col, f_block from @freq 
	order by f_row, f_col, f_block, digit, cellID




exec [sp_get_digitsThatOccur_byFreq] 2