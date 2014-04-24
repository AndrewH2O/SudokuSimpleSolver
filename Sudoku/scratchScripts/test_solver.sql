--use Sudoku
--DECLARE @result int;
--exec  @result = sp_rule_nakedSingle;
--if(@result<>-1) 
--	exec sp_eliminateCandidates;


---keep calling the above

DECLARE @result int;
set @result=0;
while @result<>-1
begin
	exec @result = sp_rule_nakedSingle;
	if(@result<>-1) 
	begin
		select 'rule "naked singles" found ' + CAST(@result as varchar(2))  + ' digits';
		exec sp_eliminateCandidates;
	end
end



exec sp_display_digits_current