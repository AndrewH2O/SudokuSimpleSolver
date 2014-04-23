use Sudoku
DECLARE @result int;
exec  @result = sp_rule_nakedSingle;
if(@result<>-1) 
	exec sp_eliminateCandidates;


---keep calling the above


exec sp_display_digits_current