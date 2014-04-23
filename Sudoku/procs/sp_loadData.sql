CREATE PROCEDURE [dbo].[sp_loadData]
	@input nvarchar(100) = ''
	
AS

DECLARE	@counter int, @valueAsInt int, @valueAsTxt nchar;
DECLARE @counterMIN int, @counterMAX int, @counter_cell int;

set @counterMIN = (select co.FIRST_CELL_ID from constants as co);
set @counterMAX = (select co.TOTAL_CELL_COUNT from constants as co);


SET @input=REPLACE(@input,' ','');
--newline
SET @input=REPLACE(@input,CHAR(13)+CHAR(10),'');
--SELECT @input as input;

if (SELECT LEN(@input)) != @counterMAX OR (SELECT PATINDEX('%[^0-9]%',@input)) !=0 
return -1;

set @counter=@counterMIN
while @counter<=@counterMAX
begin
	set @valueAsTxt = substring(@input, @counter, 1);
	if ISNUMERIC(@valueAsTxt) = 1 
	begin 
		set @valueAsInt = CAST(@ValueAsTxt AS INT);
		--print @valueAsInt;
		update dbo.cells set start = @valueAsInt where id=@counter;
	end
	set @counter = @counter+1;
end


RETURN 1
