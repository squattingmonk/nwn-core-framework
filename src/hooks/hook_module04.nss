// -----------------------------------------------------------------------------
//    File: hook_module04.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnClientLeave event hook-in scirpt. Place this script on the OnClientLeave
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetExitingObject();

    // Only execute hook-in scripts if the PC was not booted OnClientEnter.
    if (!GetLocalInt(oPC, LOGIN_BOOT))
    {
        RunEvent(MODULE_EVENT_ON_CLIENT_LEAVE);

        // Decrement the count of players in the module
        if (GetIsDM(oPC))
            RemoveListObject(OBJECT_SELF, oPC, DM_ROSTER);
        else if (GetIsPC(oPC))
            RemoveListObject(OBJECT_SELF, oPC, PLAYER_ROSTER);
    }
}
