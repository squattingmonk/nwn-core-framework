// -----------------------------------------------------------------------------
//    File: hook_module09.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnPlayerDeath event hook-in script. Place this script on the OnPlayerDeath
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetLastPlayerDied();
    RunEvent(MODULE_EVENT_ON_PLAYER_DEATH, oPC);
}
