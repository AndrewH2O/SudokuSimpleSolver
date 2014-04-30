use Sudoku
--insert sub rows/cols within block
DECLARE @lookupSubRowsCols table (
	cellID int,
	s_block int,
	s_row int,
	s_col int,
	s_subRow int,
	s_subCol int
)

declare @counter_cell int, @cellID int, @row int, @col int, @block int, @subRow int, @subCol int;
declare @offset int;
set @counter_cell = 1;
	set @offset = 1;
	while @counter_cell<=81
		begin
			set @col = @offset;
			set @row = (@counter_cell - 1)/9 + 1;
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
			
			set @subRow = @row-((@row-1)/3 * 3);
			set @subCol = @col-((@col-1)/3 * 3);
			
			INSERT INTO @lookupSubRowsCols (cellID, s_row, s_col, s_block, s_subRow, s_subCol) 
				values (@counter_cell,@row,@col,@block, @subRow, @subCol);

			set @offset=@offset+1;
			set @counter_cell = @counter_cell+1;
			if @offset>9 begin set @offset=1 end;
		end;


select * from @lookupSubRowsCols
select * from dbo.lookupRCB where s_subCol=2
