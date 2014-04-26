select concat(
' ['
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=1 and digit =1) 
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=1 and digit =2 )
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=1 and digit =3) 
,
','
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=1 and digit =4 )
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=1 and digit =5) 
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=1 and digit =6 )
,
','
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=1 and digit =7 )
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=1 and digit =8) 
,
(select cast(value as nvarchar(1)) 
from dbo.candidate_digits where cellID=1 and digit =9 )
,
'] '
)

