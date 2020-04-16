// -----------------------------------------------------------------------------
//    File: torch_i_events.nss
//  System: Torch and Lantern (events)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Event functions for PW Subsystem.
// -----------------------------------------------------------------------------
// Builder Use:
//  None!  Leave me alone.
// -----------------------------------------------------------------------------
// Acknowledgment:
// -----------------------------------------------------------------------------
//  Revision:
//      Date:
//    Author:
//   Summary:
// -----------------------------------------------------------------------------

#include "x2_inc_switches"
#include "torch_i_main"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< torch_OnSpellHook >---
// This function is a library and event registered script for the module
//  level event OnSpellHook.  This function provides a chance of failure for
//  lighting an oil flask.
void torch_OnSpellHook();

// ---< torch_oilflask >---
// This function is tag-based scripting used to refill an empty lantern
void torch_oilflask();

// ---< torch_torch >---
// This function is tag-based scripting used to add or remove light from the
//  torch when it is equipped/unequipped.
void torch_torch();

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

// ----- Module Events -----

void torch_OnSpellHook()
{
    object oItem = GetSpellCastItem();
    int spellID = GetSpellId();
    if (GetTag(oItem) == H2_OILFLASK && GetSpellId() == SPELL_GRENADE_FIRE)
    {
        if (d2()==1)
        {
            SendMessageToPC(OBJECT_SELF, H2_TEXT_OIL_FLASK_FAILED_TO_IGNITE);
            SetModuleOverrideSpellScriptFinished();
        }
    }
}

// ----- Tag-based Scripting -----

void torch_oilflask()
{
    int nEvent = GetUserDefinedItemEventNumber();
    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC   = GetItemActivator();
        object oItem = GetItemActivated();
        object oTarget = GetItemActivatedTarget();
        location loc = GetItemActivatedTargetLocation();
        if (GetIsObjectValid(oTarget))
        {
            if (GetTag(oTarget) == H2_LANTERN)
            {
                h2_FillLantern(oItem, oTarget);
                return;
            }
        }
        SendMessageToPC(oPC, H2_TEXT_CANNOT_USE_ON_TARGET);
    }
}

void torch_torch()
{
    int nEvent = GetUserDefinedItemEventNumber();

    // * This code runs when the item is equipped
    // * Note that this event fires PCs only
    if (nEvent ==  X2_ITEM_EVENT_EQUIP)
    {
        h2_EquippedLightSource(FALSE);
    }
    // * This code runs when the item is unequipped
    // * Note that this event fires for PCs only
    else if (nEvent == X2_ITEM_EVENT_UNEQUIP)
    {
        h2_UnEquipLightSource(FALSE);
    }
}
