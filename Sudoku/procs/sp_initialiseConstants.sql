CREATE PROCEDURE [dbo].[sp_initialiseConstants]
AS
	delete dbo.constants
	insert into dbo.constants
	(
		[CAGE_SIZE],[TOTAL_CELL_COUNT],       
		[CANDIDATE_DIGIT_SET],[CANDIDATE_DIGIT_NOTSET], 
		[DIGIT_OUTPUT_NOTKNOWN], [CANDIDATES_NA] ,         
		[FIRST_CELL_ID],[FIRST_DIGIT_ID]
		
	)  values
	( 
		9,81,
		1,0,
		0,0,
		1,1
		
	);    

	update dbo.constants
	set CANDIDATES_STR_ALL = '1', CANDIDATES_STR_NA='0';
	
	
RETURN 0
