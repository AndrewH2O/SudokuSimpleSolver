use Sudoku

--eliminate possible candidates for all cells
--'block' is non overlapping 3 by 3 arrangement of cells there
--are typically 9 of these
--'peer' below refers to all the intersecting cells of a
--row, column or block
DECLARE @RowIntersect int, @ColIntersect int, @BlockIntersect int
DECLARE @emptyState int, @currentcellID int, @countDelta int
DECLARE @cageSize int
DECLARE @minCellID int, @maxCellID int


--table used to record the digits found in a cells 'peer' where 
--'cellID' is the corresponding cellid in the peer that has a 
--digit and 'digit' records the digit value (note the cellID
--in this table is not to be confused with the currentcellID
--which is the id of the cell whose 'peer' we are working with)
DECLARE @tDigitsToMarkOff table
(
	cellID int,
	digit int
);


set @cageSize = (select co.CAGE_SIZE from Constants as co);
set @minCellID =(select co.FIRST_CELL_ID from Constants as co);
set @maxCellID =(select co.TOTAL_CELL_COUNT from Constants as co);
set @emptyState = (select co.DIGIT_OUTPUT_NOTKNOWN from dbo.Constants as co);

--cycle through cells and for those where no digits have been found eliminate
--candidates for each cell where there are digits in its peers.
set @currentcellID = @minCellID;
while @currentcellID<=@maxCellID
begin
	SET NOCOUNT ON;
	--eliminate candidates where no digit has been found
	if(select ca.[digit_current] from dbo.candidates as ca where ca.cellID = @currentcellID) = @emptyState 
	begin
		--DEBUG
		select @currentCellID as currentCellId
		--END DEBUG

		--get peers	
		set @RowIntersect = (select s_row from dbo.lookupRCB where cellID = @currentcellID);
		set @ColIntersect = (select s_col from dbo.lookupRCB where cellID = @currentcellID);
		set @BlockIntersect = (select s_block from dbo.lookupRCB where cellID = @currentcellID);

		--reset table
		delete @tDigitsToMarkOff;

		--take row col and block intersections for a particular cell and return a unique list of digits
		--that are in the set of 'peers'
		--'with' to enclose the query and use of over together with partition to operate on the whole query 
		--was necessary so as to select for distinct items on one column in this case ca.digit_Output
		--otherwise it is the entire row which is seen as distinct (ie entirely plausible for unique cell id 
		--but more than one having the same digit output which is not what is required here)
		--In the where clause rn=1 is used to deselect the 1+n rows where duplicates occur
		with temp as
		(
			select ce.id, ca.[digit_current], 
				ROW_NUMBER() OVER (PARTITION BY ca.[digit_current] order by ca.[digit_current]) as rn
			from dbo.cells as ce
			inner join dbo.candidates as ca on ce.id=ca.cellID
			inner join dbo.lookupRCB as l on ce.id=l.cellID

			where 
				(s_row=@RowIntersect and ca.[digit_current] <> @emptyState) 
				or 
				(s_col=@ColIntersect and ca.[digit_current] <> @emptyState) 
				or 
				(s_block=@BlockIntersect and ca.[digit_current] <> @emptyState)
	
		)
		insert into @tDigitsToMarkOff 
		select id, [digit_current] from temp where rn=1;
	

		--DEBUG
		select * from @tDigitsToMarkOff
		--END DEBUG

		--update Number of possibles
		--how many digits did we find
		set @countDelta = (select COUNT(*) from @tDigitsToMarkOff);

		--DEBUG
		select @countDelta as countDelta;
		--END DEBUG

		update ca
		set NumberPossibles = @cageSize - @countDelta
		from dbo.candidates as ca
		where ca.cellID = @currentcellID;
		

		--DEBUG
		--check what we want to update
		select cd.digit, cd.value 
		from dbo.candidate_digits as cd 
		where 
			cd.cellID = @currentcellID and
			cd.digit in (select digit from @tDigitsToMarkOff);
		--END DEBUG


		--update digits set to emptyState where there are not possible candidates
		update cd
		set cd.value = @emptyState
		from dbo.candidate_digits as cd 
		where 
			cd.cellID = @currentcellID and
			cd.digit in (select digit from @tDigitsToMarkOff);
	
	end

	--increment cellID
	set @currentcellID=@currentcellID+1
end