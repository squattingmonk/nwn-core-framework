// -----------------------------------------------------------------------------
//    File: hook_module15.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnPlayerUnEquipItem event hook-in script. Place this script on the
// OnPlayerUnEquipItem event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"
#include "x2_inc_switches"

void main()
{
    object oItem  = GetPCItemLastUnequipped();
    object oPC    = GetPCItemLastUnequippedBy();
    int    nState = RunItemEvent(MODULE_EVENT_ON_PLAYER_UNEQUIP_ITEM, oItem, oPC);

    if (ENABLE_TAGBASED_SCRIPTS && !(nState & EVENT_STATE_DENIED))
    {
        string sTag = GetTag(oItem);
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNEQUIP);
        RunLibraryScript(sTag);
    }
}
