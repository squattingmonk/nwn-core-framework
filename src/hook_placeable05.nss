// -----------------------------------------------------------------------------
//    File: hook_placeable05.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Placeable OnHeartbeat event script. Place this script on the OnHeartbeat event
// under Placeable Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(PLACEABLE_EVENT_ON_HEARTBEAT);
}
