// -----------------------------------------------------------------------------
//    File: hook_module11.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnPlayerEquipItem event hook-in script. Place this script on the OnPlayerItem
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_events"
#include "x2_inc_switches"

void main()
{
    object oItem = GetPCItemLastEquipped();
    int nState = RunTagBasedScript(oItem, X2_ITEM_EVENT_EQUIP);
    if (nState != X2_EXECUTE_SCRIPT_END)
    {
        object oPC = GetPCItemLastEquippedBy();
        RunEvent(MODULE_EVENT_ON_PLAYER_EQUIP_ITEM, oPC);
    }
}
