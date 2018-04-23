// -----------------------------------------------------------------------------
//    File: hook_trigger02.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Trigger OnEnter event script. Place this script on the OnEnter event under
// Trigger Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetEnteringObject();
    RunEvent(TRIGGER_EVENT_ON_ENTER, oPC);
    AddScriptSource(oPC);
}
