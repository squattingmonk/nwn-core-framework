// -----------------------------------------------------------------------------
//    File: hook_module12.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnPlayerLevelUp event hook-in script. Place this script on the
// OnPlayerLevelUp event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetPCLevellingUp();
    int nState = RunEvent(MODULE_EVENT_ON_PLAYER_LEVEL_UP, oPC);

    // If the PC's level up was denied, relevel him,
    if (nState & EVENT_STATE_DENIED)
    {
        int nLevel   = GetHitDice(oPC);
        int nOrigXP  = GetXP(oPC);
        int nLevelXP = (((nLevel - 1) * nLevel) / 2) * 1000;
        SetXP(oPC, nLevelXP - 1);
        DelayCommand(0.5, SetXP(oPC, nOrigXP));
    }
}
