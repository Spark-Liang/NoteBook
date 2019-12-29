-- ################################################
-- This function is to get the name that wrap by brackets.
-- ################################################

Drop function if exists [dbo].[GET_WRAP_NAME];
GO


create function [dbo].[GET_WRAP_NAME](
    @NAME as NVARCHAR(1024)
)
RETURNS NVARCHAR(2048)
AS
BEGIN
    RETURN '['+replace(@NAME,']',']]')+']'
END
