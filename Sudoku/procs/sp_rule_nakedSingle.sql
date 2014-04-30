CREATE PROCEDURE [dbo].[sp_rule_nakedSingle]
	
AS
SET NOCOUNT ON;
--applies rule 'naked singles' to set digits on cells that 
--only have 1 possible candidate
--rule named after http://www.sudocue.net/guide.php
DECLARE @counter int;
DECLARE @number_found int;
DECLARE @currentCellID int, @currentDigit int;
DECLARE @BAILOUT int;
DECLARE @BAILOUTCounter int;


DECLARE @digitsFound table 
(
	numberPossibles int,
	cellID int,
	digit int,
	value bit,
	rowNumber int primary key
);

delete @digitsFound;

set @BAILOUT=100;
set @BAILOUTCounter=0;



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

----DEBUG
--select * from @digitsFound
----end DEBUG
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
			----DEBUG
			--select * from @digitsFound where @counter=rowNumber
			----end DEBUG
			set @currentCellID=(select cellID from @digitsFound where @counter = rowNumber);
			set @currentDigit=(select digit from @digitsFound where @counter = rowNumber);
		
			exec [sp_setDigit_resetCandidates_byCellID] @currentCellID, @currentDigit;

			

			set @BAILOUTCounter=@BAILOUTCounter+1;
			if(@BAILOUTCounter>@BAILOUT)
			begin
				select '****** Naked Single Bailout ****************'
				return -1;
			end

			set @counter = @counter+1;
		end
	
	end


--set the digit current to equal digit next on those cells where a digit 
--has been found
update candidates
			set digit_current=digit_next
			from candidates where digit_current<>digit_next

exec sp_eliminateCandidates;

RETURN @number_found
