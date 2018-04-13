// -----------------------------------------------------------------------------
//    File: hook_module15.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnPlayerUnEquipItem event hook-in script. Place this script on the
// OnPlayerUnEquipItem event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_events"
#include "x2_inc_switches"

void main()
{
    object oItem = GetPCItemLastUnequipped();
    int nState = RunTagBasedScript(oItem, X2_ITEM_EVENT_UNEQUIP);
    if (nState != X2_EXECUTE_SCRIPT_END)
    {
        object oPC = GetPCItemLastUnequippedBy();
        RunEvent(MODULE_EVENT_ON_PLAYER_UNEQUIP_ITEM, oPC);
    }
}
