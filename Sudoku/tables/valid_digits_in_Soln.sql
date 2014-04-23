CREATE TABLE [dbo].[valid_digits_in_soln]
(
	[digit] INT NOT NULL PRIMARY KEY, 
    CONSTRAINT [CK_checkValidDigitsSolnRange] CHECK (digit = 1 OR digit = 2 OR digit = 3 OR digit = 4 OR digit = 5 OR digit = 6 OR digit = 7 OR digit = 8 OR digit = 9)
)

