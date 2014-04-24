CREATE PROCEDURE [dbo].[sp_setDigitAndClearCandidateByCellID]
	@cellID int,
	@digit int
AS
	DECLARE @candidateDigitNotSet bit;
	set @candidateDigitNotSet = (select CANDIDATE_DIGIT_NOTSET from constants);

	--set digit and clear possible candidate by cellID and digit
	--set candidate to not set
	update cd
	set cd.value=@candidateDigitNotSet
	from candidate_digits as cd inner join candidates as ca 
	on cd.cellID = ca.cellID
	where ca.cellID = @cellID and cd.digit=@digit 

	--update numberPossibles and set digit_next
	update ca
	set ca.numberPossibles=
		(select count(*) from candidate_digits where cellID=@cellID and value<>@candidateDigitNotSet),
		ca.digit_next = @digit
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
