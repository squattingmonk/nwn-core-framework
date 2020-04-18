// -----------------------------------------------------------------------------
//    File: hook_trigger03.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Trigger OnExit event script. Place this script on the OnExit event under
// Trigger Properties.
// -----------------------------------------------------------------------------

#include "rest_i_const"
#include "core_i_framework"

void main()
{
    object oPC = GetExitingObject();
    RemoveScriptSource(oPC);
    RunEvent(REST_EVENT_ON_TRIGGER_EXIT, oPC);
}
