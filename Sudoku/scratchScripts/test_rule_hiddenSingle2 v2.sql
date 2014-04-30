DECLARE @number_found int;
DECLARE @cellID int, @digit int;
DECLARE @frequency int;

set @number_found=0;
set @frequency=1;

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

insert into @freq (cellID,digit,f_row,f_col,f_block,f_xrefRow, f_xrefCol, f_xrefBlock, f_subRow,f_subCol)
exec [sp_get_digitsThatOccur_byFreq] @frequency;

select * from @freq;
--DECLARE @v XML = (SELECT * FROM @freq FOR XML AUTO)


set @number_found=(select count(*) from @freq);



if(@number_found!=0)
	
begin
	while(select count(*) from @freq)>0
	begin
		set @cellID = (select min(cellID) from @freq);
		set @digit = (select min(digit) from @freq where cellID=@cellID);
		select 'hidden singles 2 update'
		select @cellID, @digit;
		--exec [sp_setDigit_resetCandidates_byCellID] @cellID, @digit;
		
		delete @freq where cellID=@cellID and digit=@digit;
		select * from @freq;
	end

	--update candidates
	--		set digit_current=digit_next
	--		from candidates where digit_current<>digit_next

	--exec sp_eliminateCandidates;
	
	--return @number_Found
end