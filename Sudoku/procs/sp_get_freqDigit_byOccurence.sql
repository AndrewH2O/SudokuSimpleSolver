
--get frequency of digits 
--get the cellID and digit by occurence 
--default occurence is 1
CREATE PROCEDURE [dbo].[sp_get_freqDigit_byOccurence]
	@occurence int = 1
	
AS
DECLARE @freq table(
	cellID int,
	digit int
)

delete @freq

DECLARE @counterMin int, @counterMax int, @counter int;

set @counterMin= (select co.FIRST_DIGIT_ID from constants as co);
set @counterMax= (select co.CAGE_SIZE from constants as co);
set @counter=@counterMin;

while @counter<=@counterMax
begin


	--row
	insert into @freq
	select cd.cellID, cd.digit 
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_row=@counter and cd.value=1 and cd.digit = 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_row=@counter and cd.value=1
					group by cd.digit
					having count(*) = @occurence)
	--col
	insert into @freq
	select cd.cellID, cd.digit 
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_col=@counter and cd.value=1 and cd.digit = 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_col=@counter and cd.value=1
					group by cd.digit
					having count(*) = @occurence)

	--block
	insert into @freq
	select cd.cellID, cd.digit 
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_block=@counter and cd.value=1 and cd.digit = 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_block=@counter and cd.value=1
					group by cd.digit
					having count(*) = @occurence)

	set @counter = @counter+1
end

select * from @freq
RETURN 0
