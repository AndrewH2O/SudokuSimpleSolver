--count(s.digit_current) as count

--select block_peers.digit_current, count(block_peers.digit_current) as count
--from 
--(
--	--block peers (comprising 4 blocks)
--	select ca.cellID, ca.digit_current
--	from dbo.candidates as ca inner join dbo.lookupRCB as l 
--	on ca.cellID = l.cellID
--	where l.s_row in (select s_row from lookupRCB where s_block = 2) and l.s_block<>2
--	union
--	select ca.cellID, ca.digit_current
--	from dbo.candidates as ca inner join dbo.lookupRCB as l 
--	on ca.cellID = l.cellID
--	where l.s_col in (select s_col from lookupRCB where s_block = 2) and l.s_block<>2 
--) as block_peers
--where block_peers.digit_current 
--not in (select ca.digit_current
--		from dbo.candidates as ca inner join dbo.lookupRCB as l 
--		on ca.cellID = l.cellID
--		where l.s_block=2)
--group by block_peers.digit_current
--having count(block_peers.digit_current)>=2

/*
use temporary table to store the cell ids where the digit in question may go
 

*/
DECLARE @possibleIDs table
(
	cellID int
)



DECLARE @block int, @digit int, @digitNotFound int;
DECLARE @flag int =0; --0 all cells in block where no digit, 1 rows cross hatch with rows, 2 cols cross hatch with rows, 3 both cross hatch with rows and cols
set @block=2;
set @digit=1;
set @flag = 3;

set @digitNotFound=0;

set @flag=9;

if @flag not in (0,1,2,3) 
begin
	select 'flag out of range - setting to default value'
	set @flag=0;
end

insert into @possibleIDs (cellID) select * from (

--returns the list of cellIDs in the @block which are
--possible places for the @digit uses
--cross hatching with numerous peers of the @block to markoff 
--the @digit and excludes any @digit if already 
--found in the block
select * from 
(	
	(
		--all cells in @block
		select ca.cellID
		from candidates as ca inner join lookupRCB as l 
		on ca.cellID=l.cellID 
		where l.s_block = @block 
	)
	EXCEPT
	(
		--except for those cells in @block where the digit cannot be
		--(union as opposed to union all is used as only interested in distinct cells)
		(
			--list cellIDs for those rows that fall within the block
			--where the @digit falls within that entire row
			select l.cellID from lookupRCB as l 
			where l.s_row in 
			(
				--entire rows where @digit is set then filtered to only 
				--those rows that are also in @block
				select l.s_row
				from candidates as ca inner join lookupRCB as l 
				on ca.cellID=l.cellID 
				where ca.digit_current = @digit
				intersect
				select l.s_row
				from lookupRCB as l where s_block=@block
			) 
			and l.s_block=@block
			and ( @flag=1 or @flag=3)
		)
		union
		(
			--list cellIDs for those cols that fall within the block
			--where the @digit falls within that col
			select l.cellID  from lookupRCB as l where l.s_col in
			(
				--entire cols where @digit is set then filtered to only 
				--those cols that are also in @block
				select l.s_col
				from candidates as ca inner join lookupRCB as l 
				on ca.cellID=l.cellID 
				where ca.digit_current = @digit
				intersect
				select l.s_col
				from lookupRCB as l where s_block=@block
			) 
			and l.s_block=@block 
			and ( @flag=2 or @flag=3)
			
		)
		union
		(
			--all the cells in @block where a @digit has been found
			--also includes @digit at this point if it has been set 
			select ca.cellID 
			from candidates as ca inner join lookupRCB as l 
			on ca.cellID=l.cellID 
			where l.s_block=@block and ca.digit_current<>@digitNotFound
		)
	)
) as t
--exclude @digit if already marked off in @block
where 
not exists (select * from candidates as c 
			inner join lookupRCB as l 
			on c.cellID=l.cellID 
			where l.s_block=@block and c.digit_current=@digit)


) as x;


select * from @possibleIDs;			