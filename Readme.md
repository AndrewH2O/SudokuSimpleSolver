# Fun T-Sql project using SSDT in visual studio 2012



## Solves simple sudoku board



Solver follows human solving rules and uses terminology and samples found in http://www.sudocue.net/guide.php





## Setup

Currently deploys to (localdb)\ProjectsV12 and sql server object explorer

shows the logical organisation of the project, 



Deployement options can be changed see below



Project includes tables, sprocs and deployment otions together with scratch scripts that can be run on an adhoc basis.



1. to publish - double click on saved file Sudoku.publish.xml from here you can set the database destination but the database should be called Sudoku



2. scripts are automatically run at time of publish when added to Script.PostDeployment1.sql Note scripts referred to within must have a build action of none



3. to test solver open:   test\_solver.sql     within the scratchScripts folder and run the script. Message at the end will indicate if a solution has been found.



4. To see verbose Solver open and run the script: 	test\_solver\_from\_end\_to\_end.sql    from within the scratchscripts folder







## TODO

add unit tests as currently scripts are manually run on an adhoc basis from the scratchScripts folder



