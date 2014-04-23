﻿CREATE TABLE [dbo].[lookupRCB]
(
	[cellID] INT NOT NULL PRIMARY KEY, 
    [s_col] INT NOT NULL, 
    [s_row] INT NOT NULL, 
    [s_block] INT NOT NULL, 
    CONSTRAINT [FK_lookup_cells] FOREIGN KEY (cellID) REFERENCES [dbo].[cells](id)
)
