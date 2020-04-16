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

#include "unid_i_config"
#include "unid_i_const"
#include "unid_i_text"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< h2_UnID >---
// Sets an unacquired item as unidentifed, assuming the item has not been
//  acquired during the UnID delay (H2_UNID_DELAY) set in unid_i_config.
void h2_UnID(object oItem);

// ---< h2_UnIDOnDrop >---
// Deploys a DelayCommand function to UnID the unacquired item if the items
//  meets minimuma value requirements as set on H2_UNID_MINIMUM_VALUE in
//  unid_i_config.
void h2_UnIDOnDrop(object oItem);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void h2_UnID(object oItem)
{
    if (GetItemPossessor(oItem) == OBJECT_INVALID)
        SetIdentified(oItem, FALSE);
}

void h2_UnIDOnDrop(object oItem)
{
    if (GetItemPossessor(oItem) == OBJECT_INVALID &&
        !GetLocalInt(oItem, H2_NO_UNID) &&
        GetGoldPieceValue(oItem) > H2_UNID_MINIMUM_VALUE)
    {
        DelayCommand(IntToFloat(H2_UNID_DELAY), h2_UnID(oItem));
    }
}
