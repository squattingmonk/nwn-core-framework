// -----------------------------------------------------------------------------
//    File: hook_module13.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnPlayerRespawn event hook-in script. Place this script on the
// OnPlayerRespawn event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetLastRespawnButtonPresser();
    RunEvent(MODULE_EVENT_ON_PLAYER_RESPAWN, oPC);
}
