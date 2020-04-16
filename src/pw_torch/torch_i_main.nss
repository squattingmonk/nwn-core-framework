// -----------------------------------------------------------------------------
//    File: torch_i_main.nss
//  System: Torch and Lantern (core)
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

#include "torch_i_config"
#include "torch_i_const"
#include "torch_i_text"
#include "pw_i_core"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< h2_RemoveLight >---
// Removes ITEM_PROPERTY_LIGHT from the passed object, if it exists.
void h2_RemoveLight(object oLantern);

// ---< h2_AddLigt >---
// Adds ItemPropertyLight of normal brightness and color white to the passed
//  object.
void h2_AddLight(object oLantern);

// ---< h2_EquippedLightSource >---
// When a PC uses a light source (torch/lantern), this function determines if it
//  has the necessary fuel (if required) and how much burn time is remaining.
void h2_EquippedLightSource(int isLantern);

// ---< h2_UnEquipLightSource >---
// When a PC stops using a light source, this function sets the appropriate
//  time variables and kills the associted timer.
void h2_UnEquipLightSource(int isLantern);

// ---< h2_BurnOutLightSource >---
// When a light source can no longer function (fuel/time), this function removes
//  the light source itemproperty and either unequips or destroys the light
//  source, depending on the type (lantern = unequip, torch = destroy)
void h2_BurnOutLightSource(object oLight, int isLantern);

// ---< h2_FillLantern >---
// When a lantern requires oil, this function will add burn time to the lantern
//  and destroy the oil flask used to fill it.  
void h2_FillLantern(object oOilFlask, object oLantern);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

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
    SendMessageToPC(oPC, H2_TEXT_REMAINING_BURN + FloatToString(percentRemaining, 5, 1) + "%%");
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
