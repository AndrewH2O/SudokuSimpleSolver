CREATE PROCEDURE [dbo].[sp_setDigit_resetCandidates_byCellID]
	@cellID int,
	@digit int,
	@debug int=0
AS
	DECLARE @candidateDigitNotSet bit, @numberPossibles int, @candidatesStr nvarchar(50);
	
	set @candidateDigitNotSet = (select CANDIDATE_DIGIT_NOTSET from constants);
	set @candidatesStr = (select co.CANDIDATES_STR_NA from dbo.constants as co);


	SET NOCOUNT ON;

	if(@debug>0)
	begin
		set @numberPossibles=0;
		print concat('setting digit c,d,poss ',@cellID,',',@digit,',',@numberPossibles);
	end


	--set digit and clear possible candidate by cellID and digit
	--set candidate to not set
	update cd
	set cd.value=@candidateDigitNotSet
	from candidate_digits as cd inner join candidates as ca 
	on cd.cellID = ca.cellID
	where ca.cellID = @cellID

	--update candidate string
	EXEC sp_convert_candidatesToStr_byCellID 
			@cellID,
			@out_candidatesAsStr = @candidatesStr output;

	
		
	update ca
	set ca.numberPossibles=0,
		ca.digit_next = @digit,
		ca.asStr = @candidatesStr
	from candidates as ca inner join candidate_digits as cd 
	on ca.cellID = cd.cellID
	where ca.cellID=@cellID 

	--set digit_next
	--update ca
	--set ca.digit_next = @digit
	--from candidates as ca
	--where ca.cellID = @cellID

--test
--select ca.digit_next, ca.numberPossibles, ca.cellID, cd.digit,cd.value
--from candidates as ca inner join candidate_digits 
--as cd on ca.cellID = cd.cellID
--where ca.cellID = @cellID 
RETURN 0
