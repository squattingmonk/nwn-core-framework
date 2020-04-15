/*
Filename:           h2_torchlantrn_i
System:             torches and lanterns
Author:             Edward Beck (0100010)
Date Created:       Aug. 30, 2006
Summary:
HCR2 h2_torchlantrn_i script.
This is an include script for the torches and lanterns subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Dec 31st, 2006
Revision Author: 0100010
Revision Summary: v1.5
Adjusted code to deal with changes to timer functions.


*/

#include "h2_torchlantrn_c"
#include "h2_core_i"

const string H2_LIGHT_TIMER = "h2_lighttimer";
const string H2_LIGHT_TIMERID = "H2_LIGHT_TIMERID";
const string H2_ELAPSED_BURN = "H2_ELAPSEDBURN";
const string H2_LIGHT_EQUIPPED = "H2_LIGHT_EQUIPPED";
const string H2_EQUIPPINGPC = "H2_EQUIPPINGPC";
const string H2_NEEDS_OIL = "H2_NEEDS_OIL";

void h2_RemoveLight(object oLantern)
{
    itemproperty ip = GetFirstItemProperty(oLantern);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyType(ip) == ITEM_PROPERTY_LIGHT)
            RemoveItemProperty(oLantern, ip);
        ip = GetNextItemProperty(oLantern);
    }
}

void h2_AddLight(object oLantern)
{
    itemproperty light = ItemPropertyLight(IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE);
    AddItemProperty(DURATION_TYPE_PERMANENT, light, oLantern);
}

void h2_EquippedLightSource(int isLantern)
{
    object oLight = GetPCItemLastEquipped();
    object oPC = GetPCItemLastEquippedBy();
    int burncount = H2_TORCH_BURN_COUNT;
    if (isLantern)
    {
        if (GetLocalInt(oLight, H2_NEEDS_OIL))
        {
            SendMessageToPC(oPC, H2_TEXT_LANTERN_OUT);
            return;
        }
        burncount = H2_LANTERN_BURN_COUNT;
    }
    int timeEquipped = h2_GetSecondsSinceServerStart();
    SetLocalInt(oLight, H2_LIGHT_EQUIPPED, timeEquipped);
    int elapsedBurn = GetLocalInt(oLight, H2_ELAPSED_BURN);
    int burnLeft = burncount - elapsedBurn;
    float percentRemaining = (IntToFloat(burnLeft) / IntToFloat(burncount)) * 100.0;
    SendMessageToPC(oPC, H2_TEXT_REMAINING_BURN + FloatToString(percentRemaining, 5, 1) + "%");
    int timerID = h2_CreateTimer(oLight, H2_LIGHT_TIMER, IntToFloat(burnLeft));
    h2_StartTimer(timerID);
    SetLocalInt(oLight, H2_LIGHT_TIMERID, timerID);
    SetLocalObject(oLight, H2_EQUIPPINGPC, oPC);
}

void h2_UnEquipLightSource(int isLantern)
{
    object oLight  = GetPCItemLastUnequipped();
    if (isLantern && GetLocalInt(oLight, H2_NEEDS_OIL))
        return;
    int timeEquipped = GetLocalInt(oLight, H2_LIGHT_EQUIPPED);
    int elapsedBurn = GetLocalInt(oLight, H2_ELAPSED_BURN);
    int timeUnEquipped = h2_GetSecondsSinceServerStart();
    elapsedBurn = elapsedBurn + (timeUnEquipped - timeEquipped);
    SetLocalInt(oLight, H2_ELAPSED_BURN, elapsedBurn);
    int timerID = GetLocalInt(oLight, H2_LIGHT_TIMERID);
    h2_KillTimer(timerID);
}

void h2_BurnOutLightSource(object oLight, int isLantern)
{
    int timerID = GetLocalInt(oLight, H2_LIGHT_TIMERID);
    h2_KillTimer(timerID);
    object oPC = GetLocalObject(oLight, H2_EQUIPPINGPC);
    if (isLantern)
    {
        SendMessageToPC(oPC, H2_TEXT_LANTERN_OUT);
        h2_RemoveLight(oLight);
        SetLocalInt(oLight, H2_NEEDS_OIL, TRUE);
        AssignCommand(oPC, ActionUnequipItem(oLight));
    }
    else
    {
        SendMessageToPC(oPC, H2_TEXT_TORCH_BURNED_OUT);
        DestroyObject(oLight);
    }
}

void h2_FillLantern(object oOilFlask, object oLantern)
{
    object oPC = GetItemActivator();
    if (oPC != GetItemPossessor(oLantern))
    {
        SendMessageToPC(oPC, H2_TEXT_TARGET_ITEM_MUST_BE_IN_INVENTORY);
        return;
    }
    if (!GetLocalInt(oLantern, H2_NEEDS_OIL))
    {
        SendMessageToPC(oPC, H2_TEXT_DOES_NOT_NEED_OIL);
        return;
    }
    if (GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) == oLantern)
        AssignCommand(oPC, ActionUnequipItem(oLantern));
    h2_AddLight(oLantern);
    DeleteLocalInt(oLantern, H2_ELAPSED_BURN);
    DeleteLocalInt(oLantern, H2_NEEDS_OIL);
    DestroyObject(oOilFlask);
}
