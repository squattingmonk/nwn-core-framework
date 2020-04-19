// -----------------------------------------------------------------------------
//    File: hook_area01.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Area OnEnter event script. Place this script on the OnEnter event under Area
// Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    // Don't run this event if the entering object is a PC that is about to be
    // booted.
    object oPC = GetEnteringObject();
    WriteTimestampedLogEntry(GetName(OBJECT_SELF) + " entered by " + GetName(oPC));

    if (GetIsPC(oPC) && GetLocalInt(oPC, LOGIN_BOOT))
        return;

    SpawnScriptDebugger();

    RunEvent(AREA_EVENT_ON_ENTER, oPC);
    AddScriptSource(oPC);
}
