// -----------------------------------------------------------------------------
//    File: hook_aoe02.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// AOE OnHeartbeat event script.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(AOE_EVENT_ON_HEARTBEAT);
}
