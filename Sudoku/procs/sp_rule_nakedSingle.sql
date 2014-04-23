CREATE PROCEDURE [dbo].[sp_rule_nakedSingle]
	
AS
	DECLARE @counter int;
DECLARE @number_found int;
DECLARE @currentCellID int, @currentDigit int;

DECLARE @digitsFound table 
(
	numberPossibles int,
	cellID int,
	digit int,
	value bit,
	rowNumber int
);

with temp as
(
	select ca.numberPossibles, ca.cellID, cd.digit,cd.value,
	ROW_NUMBER() OVER (PARTITION BY ca.[digit_current] order by ca.[digit_current]) as rn
	from candidates as ca inner join candidate_digits 
	as cd on ca.cellID = cd.cellID
	where ca.numberPossibles=1 and cd.value<>0 
)
insert into @digitsFound
select numberPossibles, cellID, digit, value, rn from temp;

select * from @digitsFound

set @number_found = (select count(*) from @digitsFound);

if(@number_found=0)
	return -1;
else
	begin
		set @counter=1;
		while @counter<=@number_found
		begin
			--select * from @digitsFound where @counter=rowNumber
			set @currentCellID=(select cellID from @digitsFound where @counter = rowNumber);
			set @currentDigit=(select digit from @digitsFound where @counter = rowNumber);
		
			exec sp_setDigitAndClearCandidateByCellID @currentCellID, @currentDigit;

			set @counter = @counter+1;
		end
	
	end

update candidates
set digit_current=digit_next
from candidates where digit_current<>digit_next
RETURN 0
