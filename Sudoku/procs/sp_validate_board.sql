CREATE PROCEDURE [dbo].[sp_validate_board]
	
AS
	--validates the part or full solution
DECLARE @counterMin int, @counterMax int, @error bit, @total int;
set @counterMin=0;
set @counterMax=9;
set @total=45;
set @error=0;

while @counterMin<=@counterMax
begin
	--do rows, cols and blocks all contain unique digits
	if(
		(select count(ca.digit_current) from candidates as ca join lookupRCB as l on ca.cellID=l.cellID where l.s_block=@counterMin and ca.digit_current<>0)
		<>
		(select count(distinct ca.digit_current) from candidates as ca join lookupRCB as l on ca.cellID=l.cellID where l.s_block=@counterMin and ca.digit_current<>0)
	)set @error=1;
	

	if(
		(select count(ca.digit_current) from candidates as ca join lookupRCB as l on ca.cellID=l.cellID where l.s_row=@counterMin and ca.digit_current<>0)
		<>
		(select count(distinct ca.digit_current) from candidates as ca join lookupRCB as l on ca.cellID=l.cellID where l.s_row=@counterMin and ca.digit_current<>0)
	)set @error=1;
	

	if(
		(select count(ca.digit_current) from candidates as ca join lookupRCB as l on ca.cellID=l.cellID where l.s_col=@counterMin and ca.digit_current<>0)
		<>
		(select count(distinct ca.digit_current) from candidates as ca join lookupRCB as l on ca.cellID=l.cellID where l.s_col=@counterMin and ca.digit_current<>0)
	)set @error=1;
	

	
	--if a solution do all the digits sum to correct total
	if((select count(digit_current) from candidates where digit_current=0)=0)
	begin
		if(
			(select sum(digit_current) from candidates as ca join lookupRCB as l on ca.cellID=l.cellID where l.s_block =@counterMin)
			<> @total
			or
			(select sum(digit_current) from candidates as ca join lookupRCB as l on ca.cellID=l.cellID where l.s_row = @counterMin )
			<> @total
			or
			(select sum(digit_current) from candidates as ca join lookupRCB as l on ca.cellID=l.cellID where l.s_col = @counterMin )
			<> @total

		)set @error=1;
	end
	

	set @counterMin=@counterMin+1;
end

if (@error=1)
	RETURN -1
else
	RETURN 0
