﻿use Sudoku
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


--************************************************************
--******* Initialise *****************************************
--************************************************************
exec sp_initialise

--************************************************************
--******* Load Data ******************************************
--************************************************************
DECLARE @status int;

exec @status = sp_loadData N'010003008000500903000029000080000609070156030406000070000270000302001000600300090';

if(@status=-1)
	print 'error';
else
	exec sp_insertCandidates;

--************************************************************
--******* Eliminate Candidates *******************************
--************************************************************
exec sp_eliminateCandidates;



--************************************************************
--******* Display Board **************************************
--************************************************************
exec sp_display_digits_current



--************************************************************
--******* Run Solver *****************************************
--************************************************************
--exec sp_rule_nakedSingle
DECLARE @result int, @hasFound bit, @isSoln bit;

set @hasFound=1;
set @isSoln=0;

while ( @isSoln=0 and @hasFound=1)
begin
	
	set @hasFound=0;
	set @result=0;
	while @result<>-1
	begin
		exec @result = sp_rule_nakedSingle;
		if(@result<>-1) 
		begin
			select 'rule "naked singles" found ' + CAST(@result as varchar(2))  + ' digits';
			set @hasFound=1;
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
			set @hasFound=1;
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
			set @hasFound=1;
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
			set @hasFound=1;
			--exec sp_eliminateCandidates;
		end
	end


	set @result=0
	while @result<>-1
	begin
		exec @result=sp_rule_lockedCandidates_type1;
		if(@result<>-1) 
		begin
			select 'rule "locked candidates type 1" marked of  ' + CAST(@result as varchar(2))  + ' candidates';
			set @hasFound=1;
		end
	end


	if((select count(*) from dbo.candidates as ca where ca.digit_current=0) = 0)
		set @isSoln=1
	else
		set @isSoln=0;
end

exec @result=sp_validate_board
if (@isSoln=1 and @result=0)
	select 'solution found';
	else 
	select 'no solution found';
--select * from candidates


--************************************************************
--******* Display Board **************************************
--************************************************************
exec sp_display_digits_current

