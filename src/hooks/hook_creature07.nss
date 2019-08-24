// -----------------------------------------------------------------------------
//    File: hook_creature07.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Creature OnHeartbeat event script. Place this script on the OnHeartbeat event
// under Creature Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    SetEventDebugLevel(HEARTBEAT_DEBUG_LEVEL);
    RunEvent(CREATURE_EVENT_ON_HEARTBEAT);
}
