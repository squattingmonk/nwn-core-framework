/*
Filename:           h2_retirepc_s
System:             core (h2_retirepc nodes starting conditional script)
Author:             Edward Beck (0100010)
Date Created:       Apr. 1, 2006
Summary:

Starting conditional script that is fired for each node when the retire pc conversation is opened.
Its purpose is to set the conversation's custom tokens to the text strings assigned to them.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Jun 30th, 2006
Revision Author: edward Beck (0100010)
Revision Summary: v1.2
Added check against H2_REGISTERED_CHARACTERS_ALLOWED, only if this is greater than zero
will the retire PC menu option show up.

*/


#include "h2_core_i"



int StartingConditional()
{
    if (H2_REGISTERED_CHARACTERS_ALLOWED > 0)
    {
        SetCustomToken(2147483621, H2_TEXT_RETIRE_PC_CONV_ROOT_NODE);
        SetCustomToken(2147483622, H2_TEXT_RETIRE_PC_CONV_NEVERMIND);
        SetCustomToken(2147483623, H2_TEXT_RETIRE_PC_CONV_RETIRE_OPTION);
        SetCustomToken(2147483624, H2_TEXT_RETIRE_PC_CONV_CONFIRM_MESSAGE);
        return TRUE;
    }
    return FALSE;
}
