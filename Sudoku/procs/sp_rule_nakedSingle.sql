CREATE PROCEDURE [dbo].[sp_rule_nakedSingle]
	
AS

--applies rule 'naked singles' to set digits on cells that 
--only have 1 possible candidate
--rule named after http://www.sudocue.net/guide.php
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


--find instances where the number of possibles is 1 and then 
--for those where the digit is set as a possible candidate
--set row number so as to iterate over the results later 
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

--DEBUG
----select * from @digitsFound
--end DEBUG
set @number_found = (select count(*) from @digitsFound);


--test if digits found if not return otherwise iterate over @digitsFound
--using the row number and set the digit found and clear possible candidates
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


--set the digit current to equal digit next on those cells where a digit 
--has been found
update candidates
set digit_current=digit_next
from candidates where digit_current<>digit_next
RETURN @number_found
