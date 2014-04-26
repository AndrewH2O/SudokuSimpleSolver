--set digit and clear possible candidate by cellID and digit
update cd
set cd.value=0
from candidate_digits as cd inner join candidates as ca 
on cd.cellID = ca.cellID
where ca.cellID = 7 and cd.digit=8 

--update numberPossibles
update ca
set ca.numberPossibles=(select count(*) from candidate_digits where cellID=7 and value<>0)
from candidates as ca inner join candidate_digits as cd 
on ca.cellID = cd.cellID
where ca.cellID=7 

--set digit_next
update ca
set ca.digit_next=8
from candidates as ca
where ca.cellID = 7

--test
select ca.digit_next, ca.numberPossibles, ca.cellID, cd.digit,cd.value
from candidates as ca inner join candidate_digits 
as cd on ca.cellID = cd.cellID
where ca.cellID = 7 

select * from candidates where cellID=7

exec [sp_updateDigit_ClearCandidate_byCellID] 7,8
exec sp_resetDigitAndSetCandidateByCellID 7,8
-------------------------------------------------------------------------------------------
--reset possible candidate for a cell
--set possible candidate for the digit
update cd
set cd.value=1
from candidate_digits as cd inner join candidates as ca 
on cd.cellID = ca.cellID
where ca.cellID = 7 and cd.digit=8 

--update numberPossibles
update ca
set ca.numberPossibles=(select count(*) from candidate_digits where cellID=7 and value<>0)
from candidates as ca inner join candidate_digits as cd 
on ca.cellID = cd.cellID
where ca.cellID=7 

--reset digit_next
update ca
set ca.digit_next=0
from candidates as ca
where ca.cellID = 7

--test
select ca.digit_next, ca.numberPossibles, ca.cellID, cd.digit,cd.value
from candidates as ca inner join candidate_digits 
as cd on ca.cellID = cd.cellID
where ca.cellID = 7 and ca.numberPossibles=1 and cd.value<>0 
------------------------------------------------------------------------------



select ca.digit_next, ca.numberPossibles, ca.cellID, cd.digit,cd.value
from candidates as ca inner join candidate_digits 
as cd on ca.cellID = cd.cellID
where ca.cellID = 7 




--set digit
--get digit for cellID=7
select * from candidate_digits
where  cellID=7 and digit = 8
