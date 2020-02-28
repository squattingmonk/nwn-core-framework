// -----------------------------------------------------------------------------
//    File: hook_module01.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnAcquireItem event hook-in script. Place this script on the OnAcquireItem
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"
#include "x2_inc_switches"

void main()
{
    object oItem  = GetModuleItemAcquired();
    object oPC    = GetModuleItemAcquiredBy();
    int    nState = RunItemEvent(MODULE_EVENT_ON_ACQUIRE_ITEM, oItem, oPC);

    if (ENABLE_TAGBASED_SCRIPTS && !(nState & EVENT_STATE_DENIED))
    {
        string sTag = GetTag(oItem);
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ACQUIRE);
        RunLibraryScript(sTag);
    }
}
