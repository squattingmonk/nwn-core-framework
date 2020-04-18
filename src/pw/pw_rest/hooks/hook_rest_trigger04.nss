// -----------------------------------------------------------------------------
//    File: hook_trigger04.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Trigger OnHeartbeat event script. Place this script on the OnHeartbeat event
// under Trigger Properties.
// -----------------------------------------------------------------------------

#include "rest_i_const"
#include "core_i_framework"

void main()
{
    SetEventDebugLevel(HEARTBEAT_DEBUG_LEVEL);
    RunEvent(REST_EVENT_ON_TRIGGER_HEARTBEAT);
}
