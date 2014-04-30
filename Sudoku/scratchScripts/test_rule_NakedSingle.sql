USE Sudoku
--find all digits

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

set @BAILOUT=100;
set @BAILOUTCounter=0;

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
		
			exec [sp_updateDigit_ClearCandidate_byCellID] @currentCellID, @currentDigit;
			
			set @BAILOUTCounter=@BAILOUTCounter+1;
			if(@BAILOUTCounter>@BAILOUT)
			begin
				select '****** Naked Single Bailout ****************'
				return -1;
			end


			set @counter = @counter+1;
		end
	
	end

update candidates
	   set digit_current=digit_next
	   from candidates where digit_current<>digit_next

exec sp_eliminateCandidates

return @number_found;
-----------------------------------------------------------------------------------------------

