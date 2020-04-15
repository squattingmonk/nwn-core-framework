/*
Filename:           h2_pdataroot_s
System:             core (h2_playerdataconv root node starting conditional)
Author:             Edward Beck (0100010)
Date Created:       Apr. 1, 2006
Summary:

Starting conditional script that is fired when the player info and action item conversation
is first opened.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "h2_core_i"

int StartingConditional()
{
    SetCustomToken(2147483600, H2_TEXT_PLAYER_DATA_ITEM_CONV_ROOT_NODE);
    SetCustomToken(2147483599, H2_TEXT_RETIRE_PC_MENU_OPTION);
    SetCustomToken(2147483598, H2_TEXT_PLAYER_DATA_MENU_NOTHING);
    SetLocalInt(GetPCSpeaker(), H2_CURRENT_TOKEN_INDEX, 1);
    return TRUE;
}
