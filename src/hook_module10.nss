// -----------------------------------------------------------------------------
//    File: hook_module10.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnPlayerDying event hook-in script. Place this script on the OnPlayerDying
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetLastPlayerDying();
    RunEvent(MODULE_EVENT_ON_PLAYER_DYING, oPC);
}
