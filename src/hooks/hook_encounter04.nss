// -----------------------------------------------------------------------------
//    File: hook_encounter04.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Encounter OnHeartbeat event script. Place this script on the OnHeartbeat event
// under Encounter Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(ENCOUNTER_EVENT_ON_HEARTBEAT);
}
