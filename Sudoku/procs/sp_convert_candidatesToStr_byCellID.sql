CREATE PROCEDURE [dbo].[sp_convert_candidatesToStr_byCellID]
	@cellID int,
	@out_candidatesAsStr nvarchar(50) output
AS
select @out_candidatesAsStr = concat(

(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=@cellID and digit =1) 
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=@cellID and digit =2 )
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=@cellID and digit =3) 
,
'-'
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=@cellID and digit =4 )
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=@cellID and digit =5) 
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=@cellID and digit =6 )
,
'-'
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=@cellID and digit =7 )
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=@cellID and digit =8) 
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=@cellID and digit =9 )
,
' '
)

RETURN 0
