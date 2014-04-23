CREATE TABLE [dbo].[candidate_digits]
(
	[cellID] INT NOT NULL, 
    [digit] INT NOT NULL, 
    [value] BIT NOT NULL, 
    PRIMARY KEY ([cellID], [digit]), 
    CONSTRAINT [FK_candidate_digits_cells] FOREIGN KEY ([cellID]) REFERENCES [cells]([id])
)
