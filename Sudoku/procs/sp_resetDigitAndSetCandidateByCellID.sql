CREATE PROCEDURE [dbo].[sp_resetDigitAndSetCandidateByCellID]
	@cellID int,
	@digit int
AS
	--reset digit for the cell
	--set possible candidate for the digit

	DECLARE @candidateDigitSet bit, @digitNotKnown int;
		set @candidateDigitSet = (select CANDIDATE_DIGIT_SET from constants);
		set @digitNotKnown = (select DIGIT_OUTPUT_NOTKNOWN from constants)

	--set digit as possible candidate
	update cd
	set cd.value=@candidateDigitSet
	from candidate_digits as cd inner join candidates as ca 
	on cd.cellID = ca.cellID
	where ca.cellID = @cellID and cd.digit= @digit 

	--update numberPossibles and reset digit_next to not known 
	update ca
	set ca.numberPossibles=
		(select count(*) from candidate_digits where cellID=@cellID and value=@candidateDigitSet),
		ca.digit_next=@digitNotKnown
	from candidates as ca inner join candidate_digits as cd 
	on ca.cellID = cd.cellID
	where ca.cellID=@cellID 

--reset digit_next to not known
--update ca
--set ca.digit_next=@digitNotKnown
--from candidates as ca
--where ca.cellID = @cellID

--test
--select ca.digit_next, ca.numberPossibles, ca.cellID, cd.digit,cd.value
--from candidates as ca inner join candidate_digits 
--as cd on ca.cellID = cd.cellID
--where ca.cellID = @cellID and ca.numberPossibles=1 and cd.value=@candidateDigitSet
RETURN 0
