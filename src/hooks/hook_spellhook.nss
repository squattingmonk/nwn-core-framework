// -----------------------------------------------------------------------------
//    File: hook_spellhook.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnSpellhook event script.
// -----------------------------------------------------------------------------

#include "core_i_framework"
#include "x2_inc_switches"

void main()
{
    int nState = RunEvent(MODULE_EVENT_ON_SPELLHOOK);

    // The DENIED state stops the spell from executing
    if (nState & EVENT_STATE_DENIED)
        SetModuleOverrideSpellScriptFinished();
    else
    {
        // Handle the special case of casting a spell at an item
        object oItem = GetSpellTargetObject();

        if (GetObjectType(oItem) == OBJECT_TYPE_ITEM)
        {
            string sTag = GetTag(oItem);
            SetUserDefinedItemEventNumber(X2_ITEM_EVENT_SPELLCAST_AT);
            RunLibraryScript(sTag);
        }
    }
}
