// -----------------------------------------------------------------------------
//    File: hook_module11.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnPlayerEquipItem event hook-in script. Place this script on the OnPlayerItem
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"
#include "x2_inc_switches"

void main()
{
    object oItem  = GetPCItemLastEquipped();
    object oPC    = GetPCItemLastEquippedBy();
    int    nState = RunItemEvent(MODULE_EVENT_ON_PLAYER_EQUIP_ITEM, oItem, oPC);

    if (ENABLE_TAGBASED_SCRIPTS && !(nState & EVENT_STATE_DENIED))
    {
        string sTag = GetTag(oItem);
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_EQUIP);
        RunLibraryScript(sTag);
    }
}
