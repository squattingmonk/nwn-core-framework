// -----------------------------------------------------------------------------
//    File: hook_area02.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Area OnExit event script. Place this script on the OnExit event under Area
// Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    // Don't run this event if the exiting object is a PC that is about to be
    // booted.
    object oPC = GetExitingObject();
    if (GetIsPC(oPC) && GetLocalInt(oPC, LOGIN_BOOT))
        return;

    RemoveScriptSource(oPC);
    RunEvent(AREA_EVENT_ON_EXIT, oPC);
}
