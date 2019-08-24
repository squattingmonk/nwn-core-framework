// -----------------------------------------------------------------------------
//    File: hook_module02.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnActivateItem event hook-in script. Place this script on the OnActivateItem
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"
#include "x2_inc_switches"

void main()
{
    object oItem = GetItemActivated();
    int nState = RunTagBasedScript(oItem, X2_ITEM_EVENT_ACTIVATE);
    if (nState != X2_EXECUTE_SCRIPT_END)
    {
        object oPC = GetItemActivator();
        RunEvent(MODULE_EVENT_ON_ACTIVATE_ITEM, oPC);
    }
}
