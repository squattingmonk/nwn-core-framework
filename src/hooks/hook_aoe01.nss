// -----------------------------------------------------------------------------
//    File: hook_aoe01.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// AOE OnEnter event script.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetEnteringObject();

    if (INCLUDE_NPC_IN_AOE_ROSTER || GetIsPC(oPC))
        AddListObject(OBJECT_SELF, oPC, AOE_ROSTER, TRUE);

    RunEvent(AOE_EVENT_ON_ENTER, oPC);
}
