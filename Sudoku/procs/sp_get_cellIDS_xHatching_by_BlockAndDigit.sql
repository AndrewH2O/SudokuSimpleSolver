--returns the list of cellIDs in the @block which are
--possible places for the @digit uses
--cross hatching with numerous peers of the @block to markoff 
--the @digit and excludes any @digit if already 
--found in the block
--use flag to x hatch by either rows(1), cols(2), both(3) or none(0)
CREATE PROCEDURE [dbo].[sp_get_cellIDS_xHatching_by_BlockAndDigit]
	@block int, --block 1-9
	@digit int, --digit 1-9
	@flag int=0 --0 all cells in block where no digit, 1 rows cross hatch with rows, 2 cols cross hatch with rows, 3 both cross hatch with rows and cols
AS
SET NOCOUNT ON;
DECLARE @digitNotFound int;
set @digitNotFound=(select DIGIT_OUTPUT_NOTKNOWN from constants);

--validate flag
if @flag not in (0,1,2,3) 
begin
	--select 'flag out of range - setting to default value'
	set @flag=0;
end

--select cellIDs
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
				where ca.digit_next = @digit
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
			select l.cellID  from lookupRCB as l 
			where l.s_col in
			(
				--entire cols where @digit is set then filtered to only 
				--those cols that are also in @block
				select l.s_col
				from candidates as ca inner join lookupRCB as l 
				on ca.cellID=l.cellID 
				where ca.digit_next = @digit
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
			where l.s_block=@block and ca.digit_next<>@digitNotFound
		)
	)
) as t
--exclude @digit if already marked off in @block
where 
not exists (select * from candidates as c 
			inner join lookupRCB as l 
			on c.cellID=l.cellID 
			where l.s_block=@block and c.digit_next=@digit)



RETURN 0
