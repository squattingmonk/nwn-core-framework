// -----------------------------------------------------------------------------
//    File: corpse_i_events.nss
//  System: PC Corpse (events)
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

#include "corpse_i_main"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< corpse_OnClientEnter >---
// This function is library and event registered on the module-level
//  OnClientEnter event.  This function ensures a PC is resurrected if
//  their corpse item was resurrected while logged out and ensure they
//  do not have corpse items in their inventory
void corpse_OnClientEnter();

// ---< corpse_OnClientLeave >---
// This function is library and event registered on the module-level
//  OnClientLeave event.  This function ensures a player does not log
//  out with a corpse item in their inventory.
void corpse_OnClientLeave();

// ---< corpse_OnPlayerDeath >---
// This function is library and event registered on the module-level
//  OnPlayerDeath event.  This function creates the PC corpse upon
//  player death.
void corpse_OnPlayerDeath();

// ---< corpse_pccorpseitem >---
// This function is library registered as a tag-based scripting function and
//  handles all actions required for use of the PC corpse item.
void corpse_pccorpseitem();

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

// ----- Module Events -----

void corpse_OnClientEnter()
{
    object oPC = GetEnteringObject();
    string sUniquePCID = h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID);
    location lRessLoc = h2_GetExternalLocation(sUniquePCID + H2_RESS_LOCATION);
    if (h2_GetIsLocationValid(lRessLoc))
        h2_PerformOffLineRessurectionLogin(oPC, lRessLoc);

    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == H2_PC_CORPSE_ITEM)
            DestroyObject(oItem);
        oItem = GetNextItemInInventory(oPC);
    }
}

void corpse_OnClientLeave()
{
    object oPC = GetExitingObject();
    object oItem = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oItem))
    {
        if (GetTag(oItem) == H2_PC_CORPSE_ITEM)
        {
            location lLastDrop = GetLocalLocation(oItem, H2_LAST_DROP_LOCATION);
            object oNewToken = CopyObject(oItem, lLastDrop);
            h2_DropPlayerCorpse(oNewToken);
        }
        oItem = GetNextItemInInventory(oPC);
    }
}

void corpse_OnPlayerDeath()
{
    object oPC = GetLastPlayerDied();
    object oArea = GetArea(oPC);

    //if some other death subsystem set the player state back to alive before this one, no need to continue
    if (h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE) != H2_PLAYER_STATE_DEAD)
        return;

    if (GetLocalInt(oArea, H2_DO_NOT_CREATE_CORPSE_IN_AREA))
        return;
    if (!GetLocalInt(oPC, H2_LOGIN_DEATH))
        h2_CreatePlayerCorpse(oPC);
}

// ----- Tag-based Scripting -----

void corpse_pccorpseitem()
{
    int nEvent = GetUserDefinedItemEventNumber();
    object oPC;
    object oItem;

    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        h2_CorpseTokenActivatedOnNPC();
    }
    // * This code runs when the item is acquired
    // * Note that this event fires for PCs only
    else if (nEvent == X2_ITEM_EVENT_ACQUIRE)
    {
        oItem = GetModuleItemAcquired();
        h2_PickUpPlayerCorpse(oItem);
    }
    // * This code runs when the item is unaquired
    // * Note that this event fires for PCs only
    else if (nEvent == X2_ITEM_EVENT_UNACQUIRE)
    {
        oItem = GetModuleItemLost();
        object oPossessor = GetItemPossessor(oItem);
        if (oPossessor == OBJECT_INVALID)
            h2_DropPlayerCorpse(oItem);
        else if (GetObjectType(oPossessor) == OBJECT_TYPE_PLACEABLE)
        {
            oPC = GetModuleItemLostBy();
            CopyItem(oItem, oPC, TRUE);
            SendMessageToPC(oPC, H2_TEXT_CANNOT_PLACE_THERE);
            DestroyObject(oItem);
        }
    }
    //* This code runs when a PC or DM casts a spell from one of the
    //* standard spellbooks on the item
    else if (nEvent == X2_ITEM_EVENT_SPELLCAST_AT)
    {
        int spellID = GetSpellId();
        if (spellID == SPELL_RAISE_DEAD || spellID == SPELL_RESURRECTION)
        {
            h2_RaiseSpellCastOnCorpseToken(spellID);
            //Now abort the original spell script since the above handled it.
            SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
        }
    }
}
