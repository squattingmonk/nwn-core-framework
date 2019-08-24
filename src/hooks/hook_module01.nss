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
    // Tag-based item acquire code. This runs before the event is processed so
    // the tag-based script can set an ABORT status if needed.
    object oItem = GetModuleItemAcquired();
    int nState = RunTagBasedScript(oItem, X2_ITEM_EVENT_ACQUIRE);
    if (nState != X2_EXECUTE_SCRIPT_END)
    {
        object oPC = GetModuleItemAcquiredBy();
        RunEvent(MODULE_EVENT_ON_ACQUIRE_ITEM, oPC);
    }
}
