// -----------------------------------------------------------------------------
//    File: rest_i_items.nss
//  System: Rest (tag-based scripting)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Tag-based Scripting functions for PW Subsystem.
// -----------------------------------------------------------------------------
// Builder Use:
//  Nothing!  Leave me alone.
// -----------------------------------------------------------------------------
// Acknowledgment:
// -----------------------------------------------------------------------------
//  Revision:
//      Date:
//    Author:
//   Summary:
// -----------------------------------------------------------------------------

#include "rest_i_main"
#include "x2_inc_switches"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< rest_firewood >---
// Tag-based scripting function for using the rest system item h2_firewood.
void rest_firewood();

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void rest_firewood()
{
    int nEvent = GetUserDefinedItemEventNumber();
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC   = GetItemActivator();
        object oItem = GetItemActivated();
        h2_UseFirewood(oPC, oItem);
    }
}
