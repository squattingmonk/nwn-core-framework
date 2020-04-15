// -----------------------------------------------------------------------------
//    File: bleed_i_items.nss
//  System: Bleed Persistent World Subsystem (tag based scripting)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Tag Based Scripting functions for PW Subsystem
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

#include "bleed_i_main"
#include "x2_inc_switches"

void healWidget_OnActivateItem()
{
    int nEvent = GetUserDefinedItemEventNumber();

    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oTarget = GetItemActivatedTarget();
        if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
            return;
        h2_UseHealWidgetOnTarget(oTarget);
    }
}
