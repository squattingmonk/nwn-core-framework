// -----------------------------------------------------------------------------
//    File: hook_creature11.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Creature OnSpawn event script. Place this script on the OnSpawn event under
// Creature Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(CREATURE_EVENT_ON_SPAWN);
}
