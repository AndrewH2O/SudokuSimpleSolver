use Sudoku

DECLARE @status int;

exec @status = sp_loadData 
N'061030020
050008107
000007034
009006078
003209500
570300900
190700000
802400060
040010250';

if(@status=-1)
	print 'error';
else
	exec sp_insertCandidates;