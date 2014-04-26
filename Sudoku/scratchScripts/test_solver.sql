--use Sudoku
--DECLARE @result int;
--exec  @result = sp_rule_nakedSingle;
--if(@result<>-1) 
--	exec sp_eliminateCandidates;


---keep calling the above


--exec sp_displayStart
--exec sp_display_digits_current
--exec sp_display_Candidates_byCellID 31
--exec sp_display_Candidates_byCellID 56
--exec sp_display_Candidates_byCellID 65
--select * from candidate_digits where cellID=4
--select * from candidate_digits where cellID=65


DECLARE @result int;


set @result=0;
while @result<>-1
begin
	exec @result = sp_rule_nakedSingle;
	if(@result<>-1) 
	begin
		select 'rule "naked singles" found ' + CAST(@result as varchar(2))  + ' digits';
		--exec sp_eliminateCandidates;
	end
end



set @result=0
while @result<>-1
begin
	exec @result=sp_rule_hiddenSingles;
	if(@result<>-1) 
	begin
		select 'rule "hidden single" found ' + CAST(@result as varchar(2))  + ' digits';
		--exec sp_eliminateCandidates;
	end
end


set @result=0
while @result<>-1
begin
	exec @result=sp_rule_hiddenSingles2;
	if(@result<>-1) 
	begin
		select 'rule "hidden single type 2" found ' + CAST(@result as varchar(2))  + ' digits';
		--exec sp_eliminateCandidates;
	end
end





--select * from candidates

