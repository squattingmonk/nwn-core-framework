// -----------------------------------------------------------------------------
//    File: hook_area03.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Area OnHeartbeat event script. Place this script on the OnHeartbeat event
// under Area Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    SetEventDebugLevel(AREA_EVENT_ON_HEARTBEAT, HEARTBEAT_DEBUG_LEVEL);
    RunEvent(AREA_EVENT_ON_HEARTBEAT);
}
