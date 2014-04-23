CREATE PROCEDURE [dbo].[sp_initialise]
	
AS
	if (select count(*) from dbo.constants)=0
	begin
		exec sp_initialiseConstants;
	end
	
	DELETE FROM dbo.lookupRCB;
	DELETE FROM dbo.candidate_digits;
	DELETE FROM dbo.candidates;
	DELETE FROM dbo.cells;
	
	--counters
	DECLARE @counterMIN int, @counterMAX int, @counter_cell int;
	DECLARE @minDigitVal int, @maxDigitVal int, @counter_digit int;
	--defaults
	DECLARE @defaultValue int;
	--candidate digits
	DECLARE @numberPossibles int, @candidateDigitSet bit;
	--lookups	
	DECLARE @col int, @row int, @block int, @offset int;


	set @counterMIN = (select co.FIRST_CELL_ID from constants as co);
	set @counterMAX = (select co.TOTAL_CELL_COUNT from constants as co);
	set @defaultValue = (select co.DIGIT_OUTPUT_NOTKNOWN from constants as co);
	set @numberPossibles = (select co.CAGE_SIZE from constants as co)
	set @candidateDigitSet = (select co.CANDIDATE_DIGIT_SET from constants as co)
	set @minDigitVal = (select co.FIRST_DIGIT_ID from constants as co);
	set @maxDigitVal = (select co.CAGE_SIZE from constants as co);

	
	--initialise cellIDs and set everything else to default values
	set @counter_cell = @counterMIN;
	while @counter_cell<=@counterMAX
		begin
			INSERT INTO dbo.cells(id,start) VALUES (@counter_cell,@defaultValue);
			INSERT INTO dbo.candidates(cellID,numberPossibles,[digit_current],[digit_next]) VALUES(@counter_cell,@numberPossibles,@defaultValue,@defaultValue)
			set @counter_digit = @minDigitVal;
			while @counter_digit<=@maxDigitVal
				begin
						insert into dbo.candidate_digits (cellID,digit,value) values (@counter_cell,@counter_digit,@candidateDigitSet)
						set @counter_digit=@counter_digit+1;
				end
			set @counter_cell = @counter_cell+1;
		end;

	--update lookup data
	set @counter_cell = @counterMIN;
	set @offset = @minDigitVal;
	while @offset<=@maxDigitVal and @counter_cell<=@counterMAX
		begin
			set @col = @offset;
			set @row = (@counter_cell - 1)/@maxDigitVal + 1;
			set @block = 
			(case 
				when @row<=3 and @col<=3 then 1
				when @row<=3 and @col<=6 then 2
				when @row<=3 and @col<=9 then 3
		
				when @row<=6 and @col<=3 then 4
				when @row<=6 and @col<=6 then 5
				when @row<=6 and @col<=9 then 6	

				when @row<=9 and @col<=3 then 7
				when @row<=9 and @col<=6 then 8
				when @row<=9 and @col<=9 then 9
			end);
			
			INSERT INTO dbo.lookupRCB (cellID,s_row,s_col,s_block) values (@counter_cell,@row,@col,@block);

			set @offset=@offset+1;
			set @counter_cell = @counter_cell+1;
			if @offset>@maxDigitVal begin set @offset=@minDigitVal end;
		end;

RETURN 1
