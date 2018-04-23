// -----------------------------------------------------------------------------
//    File: hook_creature06.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Creature OnDisturbed event script. Place this script on the OnDisturbed event
// under Creature Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(CREATURE_EVENT_ON_DISTURBED, GetLastDisturbed());
}
