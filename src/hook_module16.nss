// -----------------------------------------------------------------------------
//    File: hook_module16.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnUnAcquireItem event hook-in script. Place this script on the
// OnUnAcquireItem event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_events"
#include "x2_inc_switches"

void main()
{
    object oItem = GetModuleItemLost();
    int nState = RunTagBasedScript(oItem, X2_ITEM_EVENT_UNACQUIRE);
    if (nState != X2_EXECUTE_SCRIPT_END)
    {
        object oPC = GetModuleItemAcquiredBy();
        RunEvent(MODULE_EVENT_ON_UNACQUIRE_ITEM, oPC);
    }
}
