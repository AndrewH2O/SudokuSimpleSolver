/*
Use of cross hatching by taking a block and marking off intersecting rows and
columns where a particular digit appears where this then leaves only a single
cell in the block that the digit can occur in.
(this technique does not need to make reference to any candidates just
uses cross hatching to markoff digits already found within the block)
*/
CREATE PROCEDURE [dbo].[sp_rule_hiddenSingles]
AS
SET NOCOUNT ON;

DECLARE @digit_counter int, @digit_counterMin int,@digit_counterMax int; 
DECLARE @block_counter int,  @block_counterMin int, @block_counterMax int;
DECLARE @cellFound int;
DECLARE @number_Found int;
DECLARE @BAILOUT int;
DECLARE @BAILOUTCounter int;

DECLARE @possibleIDs table
(
	cellID int primary key
);

set @digit_counterMin = (select FIRST_DIGIT_ID from constants);
set @digit_counterMax = (select CAGE_SIZE from constants);

set @block_counterMin = @digit_counterMin;
set @block_counterMax = @digit_counterMax;



set @cellFound = 0;
set @block_counter=@block_counterMin;
set @digit_counter=@digit_counterMin;

set @number_Found=0;

set @BAILOUT=100;
set @BAILOUTCounter=0;

while @block_counter<=@block_counterMax
begin
	
	set @digit_counter=@digit_counterMin
	while @digit_counter<=@digit_counterMax
	begin
		
		delete @possibleIDs;
		--markoff all digits by crosshatching and get back list of all cellIDs remaining where
		--a digit is to be found
		insert into @possibleIDs exec sp_get_cellIDS_xHatching_by_BlockAndDigit @block_counter, @digit_counter, 3;
		
		----DEBUG
		--select * from @possibleIDs;
		----end DEBUG
		
		--special case where xhatching eliminates all but one cell
		--means that in the block this is the only place the digit could go
		if (select count(*) from @possibleIDs) = 1
		begin
			--found digit
			set @cellFound=(select cellID from @possibleIDs);
			set @number_Found = @number_Found+1;
			----DEBUG
			--select 'rule "hidden single" found digit '+ CAST(@digit_counter as varchar(2)) +' for cellID ' + CAST(@cellFound as varchar(2)) ;
			----end DEBUG
			exec [sp_setDigit_resetCandidates_byCellID] @cellFound, @digit_counter;
			
			
		end

		set @BAILOUTCounter=@BAILOUTCounter+1;
		if(@BAILOUTCounter>@BAILOUT)
		begin
			select '****** Hidden Single Bailout ****************'
			return -1;
		end
		
		set @digit_counter=@digit_counter+1;
	end
	
	set @block_counter = @block_counter+1;
end


if(@number_found=0)
	return -1;
else
begin
	update candidates
			set digit_current=digit_next
			from candidates where digit_current<>digit_next

	exec sp_eliminateCandidates;
	
	return @number_Found
end
