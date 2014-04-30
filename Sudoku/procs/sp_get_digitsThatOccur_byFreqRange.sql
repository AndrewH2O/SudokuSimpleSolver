﻿CREATE PROCEDURE [dbo].[sp_get_digitsThatOccur_byFreqRange]
	@frequencyMin int = 2,
	@frequencyMax int = 3
AS
SET NOCOUNT ON;

if(@frequencyMin>@frequencyMax)return -1;

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

delete @freq

DECLARE @counterMin int, @counterMax int, @counter int;

set @counterMin= (select co.FIRST_DIGIT_ID from constants as co);
set @counterMax= (select co.CAGE_SIZE from constants as co);
set @counter=@counterMin;

while @counter<=@counterMax
begin


	--row
	insert into @freq (cellID, digit, f_row, f_col, f_block, f_xrefRow, f_xrefCol, f_xrefBlock, f_subRow,f_subCol)
	select cd.cellID, cd.digit, l.s_row, 0, 0 , l.s_row, l.s_col, l.s_block, l.s_subRow,l.s_subCol
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_row=@counter and cd.value=1 and cd.digit in 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_row=@counter and cd.value=1
					group by cd.digit
					having count(*) >= @frequencyMin and count(*) <= @frequencyMax)
	--col
	insert into @freq (cellID, digit, f_row, f_col, f_block, f_xrefRow, f_xrefCol, f_xrefBlock, f_subRow,f_subCol)
	select cd.cellID, cd.digit, 0, l.s_col, 0 , l.s_row, l.s_col, l.s_block, l.s_subRow, l.s_subCol
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_col=@counter and cd.value=1 and cd.digit in 
			(select cd.digit 
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_col=@counter and cd.value=1
					group by cd.digit
					having count(*) >= @frequencyMin and count(*) <= @frequencyMax)

	--block
	insert into @freq (cellID, digit, f_row, f_col, f_block, f_xrefRow, f_xrefCol, f_xrefBlock, f_subRow, f_subCol)
	select cd.cellID, cd.digit, 0, 0, l.s_block, l.s_row, l.s_col, l.s_block, l.s_subRow, l.s_subCol
	from dbo.candidate_digits  as cd 
		join dbo.lookupRCB as l 
			on cd.cellID=l.cellID
			where l.s_block=@counter and cd.value=1 and cd.digit in 
			(select cd.digit  
				from dbo.candidate_digits  as cd 
				join dbo.lookupRCB as l 
					on cd.cellID=l.cellID
					where l.s_block=@counter and cd.value=1
					group by cd.digit
					having count(*) >= @frequencyMin and count(*) <= @frequencyMax)

	set @counter = @counter+1
end

select cellID, digit, f_row, f_col, f_block, f_xrefRow, f_xrefCol, f_xrefBlock, f_subRow, f_subCol from @freq
RETURN 0
