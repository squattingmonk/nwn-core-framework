// -----------------------------------------------------------------------------
//    File: hook_door06.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Door OnHeartbeat event script. Place this script on the OnHeartbeat event
// under Door Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(DOOR_EVENT_ON_HEARTBEAT);
}
