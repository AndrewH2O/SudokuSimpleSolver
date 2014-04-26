use Sudoku

DECLARE @freq table(
	cellID int,
	digit int
)

delete @freq

DECLARE @index int, @occurence int, @counter int;
set @index=2
set @occurence=1
set @counter=1;

while @counter<=9
begin

set @index=@counter
	--row
	insert into @freq
	select cd.cellID, cd.digit 
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_row=@index and cd.value=1 and cd.digit = 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_row=@index and cd.value=1
					group by cd.digit
					having count(*) = @occurence)
	--col
	insert into @freq
	select cd.cellID, cd.digit 
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_col=@index and cd.value=1 and cd.digit = 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_col=@index and cd.value=1
					group by cd.digit
					having count(*) = @occurence)

	--block
	insert into @freq
	select cd.cellID, cd.digit 
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_block=@index and cd.value=1 and cd.digit = 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_block=@index and cd.value=1
					group by cd.digit
					having count(*) = @occurence)

	set @counter = @counter+1
end

select * from @freq

select min(cellID) from @freq