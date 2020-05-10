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
    object oPC = GetEnteringObject();

    if (GetIsPC(oPC))
    {
        if (GetLocalInt(oPC, LOGIN_BOOT))
            return;

        if (ENABLE_ON_AREA_EMPTY_EVENT)
        {
            int nTimerID = GetLocalInt(OBJECT_SELF, TIMER_ON_AREA_EMPTY);
            if (GetIsTimerValid(nTimerID))
                KillTimer(nTimerID);
        }

        AddListObject(OBJECT_SELF, oPC, AREA_ROSTER, TRUE);
    }

    RunEvent(AREA_EVENT_ON_ENTER, oPC);
    AddScriptSource(oPC);
}
