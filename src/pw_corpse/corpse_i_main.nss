/*
Filename:           h2_pcorpse_i
System:             pc corpse (include script)
Author:             Edward Beck (0100010)
Date Created:       Mar. 12, 2006
Summary:
HCR2 h2_pccorpse system function definition file.
This script is consumed by the various pc corpse system scripts as an include file.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Dec 31st, 2006
Revision Author: 0100010
Revision Summary: v1.5
Fixed bug where an NPC cleric would not raise a PC from a token
if H2_ALLOW_CORPSE_RESS_BY_PLAYERS was false.
Fixed bug where NPC cleric had to have gold on them to raise a PC
if H2_REQUIRE_GOLD_FOR_RESS was true.
(cost was already taken care of in the NPC's user defined event when the token was
activated on them.)
Changed code to use new gold cost configuration variables.
*/

#include "corpse_i_const"
#include "corpse_i_config"
#include "corpse_i_text"
#include "pw_i_core"

//This handles moving the pc corpse copy and cleaning up the death corpse container
//whenever the oCorpseToken item is picked up by a PC.
void h2_PickUpPlayerCorpse(object oCorpseToken);

//This handles moving the pc corpse copy and creating he death corpse container
//whenever the oCorpseToken item is dropped by a PC.
void h2_DropPlayerCorpse(object oCorpseToken);

//This handles the creation of the pc corpse copy of oPC, creation
//of the death corpse container and the token item used to move the corpse copy around by
//other PCs when oPC dies.
void h2_CreatePlayerCorpse(object oPC);

//Handles when the corpse token is activated and targeted on on NPC.
void h2_CorpseTokenActivatedOnNPC();

void h2_PickUpPlayerCorpse(object oCorpseToken)
{
    string uniquePCID = GetLocalString(oCorpseToken, H2_DEAD_PLAYER_ID);
    object oDC = GetObjectByTag(H2_CORPSE + uniquePCID);
    object oWayPt = GetObjectByTag(H2_WP_DEATH_CORPSE);
    object oDC2;
    if (GetIsObjectValid(oDC))
    {
        oDC2 = CopyObject(oDC, GetLocation(oWayPt));
        AssignCommand(oDC, SetIsDestroyable(TRUE, FALSE));
        DestroyObject(oDC);
    }
}

void h2_DropPlayerCorpse(object oCorpseToken)
{
    string uniquePCID = GetLocalString(oCorpseToken, H2_DEAD_PLAYER_ID);
    object oDC = GetObjectByTag(H2_CORPSE + uniquePCID);
    //TODO: randomize location a bit to prevent corpse stacking?
    object oDeathCorpse;
    if (GetIsObjectValid(oDC))
    {   //if the dead player corpse copy exists, use it & the invisible object DC container
        object oDC2 = CopyObject(oDC, GetLocation(oCorpseToken));
        oDeathCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, H2_DEATH_CORPSE, GetLocation(oDC2));
        DestroyObject(oDC);
    }
    else
    {   //if the dead player corpse copy doesn't exist, use the alternate plague body placeable as the DC container
        oDeathCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, H2_DEATH_CORPSE2, GetLocation(oCorpseToken));
    }
    SetName(oDeathCorpse, GetName(oCorpseToken));
    object oNewToken = CopyItem(oCorpseToken, oDeathCorpse, TRUE);
    SetLocalLocation(oNewToken, H2_LAST_DROP_LOCATION, GetLocation(oDeathCorpse));
    DestroyObject(oCorpseToken);
}

void h2_CreatePlayerCorpse(object oPC)
{
    string uniquePCID = h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID);
    location loc = GetLocalLocation(oPC, H2_LOCATION_LAST_DIED);
    object oDeadPlayer = CopyObject(oPC, loc, OBJECT_INVALID, H2_CORPSE + uniquePCID);
    SetName(oDeadPlayer, H2_TEXT_CORPSE_OF + GetName(oPC));
    ChangeToStandardFaction(oDeadPlayer, STANDARD_FACTION_COMMONER);
    // remove gold, inventory & equipped items from dead player corpse copy
    h2_DestroyNonDroppableItemsInInventory(oDeadPlayer);
    h2_MovePossessorInventory(oDeadPlayer, TRUE);
    h2_MoveEquippedItems(oDeadPlayer);
    AssignCommand(oDeadPlayer, SetIsDestroyable(FALSE, FALSE));
    AssignCommand(oDeadPlayer, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oDeadPlayer));
    object oDeathCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, H2_DEATH_CORPSE, GetLocation(oDeadPlayer));
    object oCorpseToken = CreateItemOnObject(H2_PC_CORPSE_ITEM, oDeathCorpse);
    SetName(oCorpseToken, H2_TEXT_CORPSE_OF + GetName(oPC));
    SetName(oDeathCorpse, GetName(oCorpseToken));
    SetLocalLocation(oCorpseToken, H2_LAST_DROP_LOCATION, GetLocation(oDeathCorpse));
    SetLocalString(oCorpseToken, H2_DEAD_PLAYER_ID, uniquePCID);
}

void h2_CorpseTokenActivatedOnNPC()
{
    object oPC = GetItemActivator();
    object oItem = GetItemActivated();
    object oTarget = GetItemActivatedTarget();
    if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        SetLocalObject(oTarget, H2_PCCORPSE_ITEM_ACTIVATOR, oPC);
        SetLocalObject(oTarget, H2_PCCORPSE_ITEM_ACTIVATED, oItem);
        SignalEvent(oTarget, EventUserDefined(H2_PCCORPSE_ITEM_ACTIVATED_EVENT_NUMBER));
    }
}

int h2_XPLostForRessurection(object oRaisedPC)
{
    int xplevel = 0;
    int i;
    for (i = 1; i < GetHitDice(oRaisedPC); i++)
    {
        xplevel = xplevel + 1000*(i - 1);
    }
    xplevel = xplevel + 500*(i-1);
    return GetXP(oRaisedPC) - xplevel;
}

int h2_GoldCostForRessurection(object oCaster, int spellID)
{
    if (spellID == SPELL_RAISE_DEAD)
    {
        if (GetGold(oCaster) < H2_GOLD_COST_FOR_RAISE_DEAD)
            return 0;
        return H2_GOLD_COST_FOR_RAISE_DEAD;
    }
    else
    {
        if (GetGold(oCaster) < H2_GOLD_COST_FOR_RESSURECTION)
            return 0;
        return H2_GOLD_COST_FOR_RESSURECTION;
    }
}

void h2_RaiseSpellCastOnCorpseToken(int spellID, object oToken = OBJECT_INVALID)
{
    if (!GetIsObjectValid(oToken))
        oToken = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    location castLoc = GetLocation(oCaster);
    string uniquePCID = GetLocalString(oToken, H2_DEAD_PLAYER_ID);
    object oPC = h2_FindPCWithGivenUniqueID(uniquePCID);
    if (!GetIsDM(oCaster))
    {
        if (H2_ALLOW_CORPSE_RESS_BY_PLAYERS == FALSE && GetIsPC(oPC))
            return;
        if (H2_REQUIRE_GOLD_FOR_RESS && GetIsPC(oCaster))
        {
            int goldCost = h2_GoldCostForRessurection(oCaster, spellID);
            if (goldCost <= 0)
            {
                SendMessageToPC(oCaster, H2_TEXT_NOT_ENOUGH_GOLD);
                return;
            }
            else
                TakeGoldFromCreature(goldCost, oCaster, TRUE);
        }

        if (spellID == SPELL_RAISE_DEAD)
        {
            int cHP = GetCurrentHitPoints(oPC);
            if (cHP > GetHitDice(oPC))
            {
                effect eDam = EffectDamage(cHP - GetHitDice(oPC));
                ApplyEffectToObject(DURATION_TYPE_INSTANT,  eDam, oPC);
            }
        }
        else
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
        if (H2_APPLY_XP_LOSS_FOR_RESS)
        {
            int lostXP = h2_XPLostForRessurection(oPC);
            GiveXPToCreature(oPC, -lostXP);
        }
    }
    else
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);

    effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, castLoc);
    DestroyObject(oToken);
    string sMessage;
    if (GetIsPC(oCaster))
        sMessage = GetName(oCaster) + "_" + GetPCPlayerName(oCaster);
    else
        sMessage = "NPC " + GetName(oCaster) + " (" + H2_TEXT_CORPSE_TOKEN_USED_BY + GetName(oPC) + "_" + GetPCPlayerName(oPC) + ") ";

    sMessage + H2_TEXT_RESS_PC_CORPSE_ITEM;

    if (GetIsObjectValid(oPC) && GetIsPC(oPC))
    {
        SendMessageToPC(oPC, H2_TEXT_YOU_HAVE_BEEN_RESSURECTED);
        h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_ALIVE);
        AssignCommand(oPC, JumpToLocation(castLoc));
        sMessage += GetName(oPC) + "_" + GetPCPlayerName(oPC);
    }
    else //player was offline
    {
        SendMessageToPC(oCaster, H2_TEXT_OFFLINE_RESS_CASTER_FEEDBACK);
        h2_SetExternalLocation(uniquePCID + H2_RESS_LOCATION, castLoc);
        if (GetIsDM(oCaster))
            h2_SetExternalInt(uniquePCID + H2_RESS_BY_DM, TRUE);
        sMessage += H2_TEXT_OFFLINE_PLAYER + " " + h2_GetExternalString(uniquePCID);
    }
    SendMessageToAllDMs(sMessage);
    WriteTimestampedLogEntry(sMessage);
}

void h2_PerformOffLineRessurectionLogin(object oPC, location ressLoc)
{
    string uniquePCID = h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID);
    h2_DeleteExternalVariable(uniquePCID + H2_RESS_LOCATION);
    h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_ALIVE);
    SendMessageToPC(oPC, H2_TEXT_YOU_HAVE_BEEN_RESSURECTED);
    DelayCommand(H2_CLIENT_ENTER_JUMP_DELAY, AssignCommand(oPC, JumpToLocation(ressLoc)));
    if (H2_APPLY_XP_LOSS_FOR_RESS && !h2_GetExternalInt(uniquePCID + H2_RESS_BY_DM))
    {
        int lostXP = h2_XPLostForRessurection(oPC);
        GiveXPToCreature(oPC, -lostXP);
    }
    h2_DeleteExternalVariable(uniquePCID + H2_RESS_BY_DM);
    string sMessage = GetName(oPC) + "_" + GetPCPlayerName(oPC) + H2_TEXT_OFFLINE_RESS_LOGIN;
    SendMessageToAllDMs(sMessage);
    WriteTimestampedLogEntry(sMessage);
}

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

