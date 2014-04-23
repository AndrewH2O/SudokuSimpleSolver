CREATE PROCEDURE [dbo].[sp_insertCandidates]
	
AS
delete from dbo.candidates
delete from dbo.candidate_digits

--majority of variables added for better readability and intent
DECLARE @outerCtr int, @innerCtr int;
DECLARE @statePossCandidate bit, @stateNotACandidate bit, @startDigit int;
DECLARE @minCellID int, @maxCellID int;
DECLARE @maxDigitValue int, @minDigitValue int;
DECLARE @digitUnknown int, @maxNumberPossibleCandidates int, @candidatesNA int;

--set variables to constant values
set @statePossCandidate =(select co.CANDIDATE_DIGIT_SET from constants as co); 
set @stateNotACandidate =(select co.CANDIDATE_DIGIT_NOTSET from constants as co);
set @candidatesNA = (select co.CANDIDATES_NA from constants as co);
set @digitUnknown = (select co.DIGIT_OUTPUT_NOTKNOWN from constants as co);
set @maxNumberPossibleCandidates = (select co.CAGE_SIZE from constants as co);

set @minCellID =(select co.FIRST_CELL_ID from constants as co);
set @maxCellID =(select co.TOTAL_CELL_COUNT from constants as co);
set @minDigitValue =(select co.FIRST_DIGIT_ID from constants as co);
set @maxDigitValue = (select co.CAGE_SIZE from constants as co);

set @startDigit=@minDigitValue;
--start iterating through cells check if digit there is a digit in the cell
--and iterate through possible digits and update with initial default values
set @outerCtr= @minCellID;
while @outerCtr<=@maxCellID
begin
	SET NOCOUNT ON;
	set @startDigit = (select start from dbo.cells where id=@outerCtr);
	
	begin
		--set candidates no digit given to use
		IF (@startDigit) = @digitUnknown 
			begin
				insert into dbo.candidates (cellID,numberPossibles,[digit_current],[digit_next]) values (@outerCtr,@maxNumberPossibleCandidates,@startDigit,@digitUnknown);
				set @innerCtr=@minDigitValue;
				while @innerCtr<=@maxDigitValue
				begin
					insert into dbo.candidate_digits (cellID, digit, value) values (@outerCtr,@innerCtr,@statePossCandidate);
					set @innerCtr = @innerCtr+1;
				end
				
			end
		ELSE
			begin 
				insert into dbo.candidates (cellID,numberPossibles,[digit_current],[digit_next]) values (@outerCtr,@candidatesNA,@startDigit,@startDigit);
				--unwind loop for setting digits
				set @innerCtr=@minDigitValue;
				while @innerCtr<=@maxDigitValue
				begin
					insert into dbo.candidate_digits (cellID, digit, value) values (@outerCtr,@innerCtr,@stateNotACandidate);
					set @innerCtr = @innerCtr+1;
				end
			end
	end
	set @outerCtr = @outerCtr+1;
end

RETURN 0