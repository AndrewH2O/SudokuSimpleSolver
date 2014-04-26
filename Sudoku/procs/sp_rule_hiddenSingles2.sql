--find any cell in a cage that is the only candidata for  digit
--and set that digit
CREATE PROCEDURE [dbo].[sp_rule_hiddenSingles2]
	
AS
DECLARE @number_found int;
DECLARE @cellID int, @digit int;
DECLARE @occurence int;

set @number_found=0;
set @occurence=1;

DECLARE @freq table(
	cellID int,
	digit int
)

delete @freq 

insert into @freq (cellID,digit)
exec [sp_get_freqDigit_byOccurence] @occurence;

set @number_found=(select count(*) from @freq);



if(@number_found=0)
	return -1;
else
begin
	while(select count(*) from @freq)>0
	begin
		set @cellID = (select min(cellID) from @freq);
		set @digit = (select digit from @freq where cellID=@cellID);
		
		exec [sp_setDigit_resetCandidates_byCellID] @cellID, @digit;
		
		delete @freq where cellID=@cellID;
	end

	update candidates
			set digit_current=digit_next
			from candidates where digit_current<>digit_next

	exec sp_eliminateCandidates;
	
	return @number_Found
end
