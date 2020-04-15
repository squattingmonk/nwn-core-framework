/*
Filename:           h2_retirepc_a
System:             core (action script on dialog h2_retirepcfugue)
Author:             Edward Beck (0100010)
Date Created:       Jan. 24, 2006
Summary:

Action script for a dialog option that results in the PC getting retired.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_core_i"

void main()
{
    object oPC = GetPCSpeaker();
    h2_MovePossessorInventory(oPC, TRUE);
    h2_MoveEquippedItems(oPC);
    h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_RETIRED);
    int registeredCharCount = h2_GetExternalInt(GetPCPlayerName(oPC) + H2_REGISTERED_CHAR_SUFFIX);
    h2_SetExternalInt(GetPCPlayerName(oPC) + H2_REGISTERED_CHAR_SUFFIX, registeredCharCount - 1);
    SendMessageToPC(oPC, H2_TEXT_TOTAL_REGISTERED_CHARS + IntToString(registeredCharCount - 1));
    SendMessageToPC(oPC, H2_TEXT_MAX_REGISTERED_CHARS + IntToString(H2_REGISTERED_CHARACTERS_ALLOWED));
    h2_BootPlayer(oPC, H2_TEXT_RETIRED_PC_BOOT, 10.0);
}
