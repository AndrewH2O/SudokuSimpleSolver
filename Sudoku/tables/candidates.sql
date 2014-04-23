CREATE TABLE [dbo].[candidates]
(
	[cellID] INT NOT NULL PRIMARY KEY, 
    [numberPossibles] INT NULL, 
    [digit_current] INT NOT NULL DEFAULT 0, 
    [digit_next] INT NULL DEFAULT 0, 
    CONSTRAINT [FK_candidates_cells] FOREIGN KEY ([cellID]) REFERENCES [cells]([id]) 
)
