CREATE PROCEDURE [dbo].[sp_simple_Solver]
	
AS
SET NOCOUNT ON;

DECLARE @result int;
DECLARE @hasFound bit;
DECLARE @isSoln bit;
DECLARE @outcome int;
DECLARE @BAILOUT int;
DECLARE @BAILOUTCounter int;

set @hasFound=1;
set @isSoln=0;
set @outcome=0;
set @BAILOUT=100;
set @BAILOUTCounter=0;

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

	--check bailout
	set @BAILOUTCounter=@BAILOUTCounter+1;
	if(@BAILOUTCounter>@BAILOUT)
	begin
		select '****** Simple Solver Bailout ****************'
		return -1;
	end
end

exec @result=sp_validate_board
if (@isSoln=1 and @result=0)
	begin
		select 'solution found';
		set @outcome=1;
	end
else 
	begin
		select 'no solution found';
		set @outcome=-1;
	end


return @outcome

