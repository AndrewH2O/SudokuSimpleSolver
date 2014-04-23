CREATE TABLE [dbo].[candidates]
(
	[cellID] INT NOT NULL PRIMARY KEY, 
    [numberPossibles] INT NULL, 
    [digit_output] INT NOT NULL DEFAULT 0, 
    CONSTRAINT [FK_candidates_cells] FOREIGN KEY ([cellID]) REFERENCES [cells]([id]) 
)
