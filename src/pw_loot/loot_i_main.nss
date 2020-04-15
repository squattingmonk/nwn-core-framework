// -----------------------------------------------------------------------------
//    File: unid_i_main.nss
//  System: UnID Item on Drop (core)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Core functions for PW Subsystem.
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

#include "pw_i_core"
#include "loot_i_config"
#include "loot_i_const"
#include "loot_i_text"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< h2_CreateLootBag >---
//Creates an item to hold the items of oPC while they are dead or dying.
object h2_CreateLootBag(object oPC);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

object h2_CreateLootBag(object oPC)
{
    object oLootBag = GetLocalObject(oPC, H2_LOOT_BAG);
    location lLootBag = GetLocation(oLootBag);
    location lPlayer = GetLocation(oPC);
    if (!GetIsObjectValid(oLootBag) || GetDistanceBetweenLocations(lPlayer, lLootBag) > 3.0 ||
        GetAreaFromLocation(lLootBag) != GetArea(oPC))
    {
        oLootBag = CreateObject(OBJECT_TYPE_PLACEABLE, H2_LOOT_BAG, GetLocation(oPC));
        //TODO: set the name of the lootbag using 1.67 patch SetName fuction?
        SetLocalObject(oPC, H2_LOOT_BAG, oLootBag);
    }
    return oLootBag;
}
