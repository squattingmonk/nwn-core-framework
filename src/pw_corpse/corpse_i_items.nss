/*
Filename:           h2_pccorpse
System:             pc corpse (token corpse item script)
Author:             Edward Beck (0100010)
Date Created:       Jan. 25, 2006
Summary:
pccorpse item event script.
This script fires whenever the h2_pccorpse items are aquired, unaquired, activated
or had a spell cast at it.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "corpse_i_main"
#include "x2_inc_switches"

void corpse_pccorposeitem()
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
