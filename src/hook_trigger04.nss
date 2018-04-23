// -----------------------------------------------------------------------------
//    File: hook_trigger04.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Trigger OnHeartbeat event script. Place this script on the OnHeartbeat event
// under Trigger Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(TRIGGER_EVENT_ON_HEARTBEAT);
}
