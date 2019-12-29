-- #####################################


drop proc if exists[dbo].[PRINT_ERROR_MSG];
GO
create PROCEDURE [dbo].[PRINT_ERROR_MSG]
as 
BEGIN

    --  config common variable
    declare @error_number as INT;
    declare @error_msg as NVARCHAR(max);
    declare @error_severity as int;
    declare @error_state as int;
    declare @error_line as int;
    declare @error_procedure as nvarchar(128);

    select 
        @error_number = ERROR_NUMBER()
        ,@error_msg = ERROR_MESSAGE()
        ,@error_severity = ERROR_SEVERITY()
        ,@error_state = ERROR_STATE()
        ,@error_line = ERROR_LINE()
        ,@error_procedure = ERROR_PROCEDURE()
    ;
    print REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            'Current nest level <NESTLEVEL>,Msg <ERROR_NUMBER>, Level <ERROR_SEVERITY>, State <ERROR_STATE>, Procedure <ERROR_PROCEDURE>, Line <ERROR_LINE> [Batch Start Line 0]'+CHAR(10)+'<ERROR_MESSAGE>'
            ,'<NESTLEVEL>',convert(varchar(10),@@NESTLEVEL - 1))
            ,'<ERROR_NUMBER>',convert(varchar(10),@error_number))
            ,'<ERROR_SEVERITY>',convert(varchar(10),@error_severity))
            ,'<ERROR_STATE>',convert(varchar(10),@error_state))
            ,'<ERROR_PROCEDURE>',coalesce(@error_procedure,''))
            ,'<ERROR_LINE>',convert(varchar(10),@error_line))
            ,'<ERROR_MESSAGE>',@error_msg
    )
END