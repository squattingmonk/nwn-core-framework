/*
Filename:           dksn_hungerthrst_t
System:             Dark Sun hunger and thirst add-ons to the HCR HT system
Author:             tinygiant
Date Created:       20200125
Summary:
dksn_hungerthrst_t text script.
This is a text script for the Dark Sun hunger and thirst subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

//There are extra spaces on this simply to make the Bars aligned since letters widths are not constant
//in the client text feedback.

#include "ds_htf_i_main"
#include "htf_i_main"

void ds_htf_KillTravelCostTimer()
{
    object oCreature = OBJECT_SELF;
    DeleteLocalString(oCreature, DKSN_HTF_LAST_TRAVEL_COST_PAID);
    h2_KillTimer(GetLocalInt(oCreature, DKSN_HTF_VARIABLE_KILLTIMER));
    DeleteLocalInt(oCreature, DKSN_HTF_VARIABLE_KILLTIMER);
}

void ds_htf_TravelCostTimerExpirationHT()
{
    object oCreature = OBJECT_SELF;

    float thirstDrop = h2_GetThirstDecrement(oCreature);
    float hungerDrop = h2_GetHungerDecrement();

    float fThirstDecrement = ds_ModifyThirstDecrementUnit(oCreature, thirstDrop);
    float fHungerDecrement = ds_ModifyHungerDecrementUnit(oCreature, hungerDrop);

    h2_PerformHungerThirstCheck(oCreature, fThirstDecrement, fHungerDecrement);

    if(!GetIsPC(oCreature) && GetIsPC(GetMaster(oCreature)))
    {
        float fThirst = GetLocalFloat(oCreature, H2_HT_CURR_THIRST) * 100.0;
        float fHunger = GetLocalFloat(oCreature, H2_HT_CURR_HUNGER) * 100.0;
        float fFatigue = GetLocalFloat(oCreature, H2_CURR_FATIGUE) * 100.0;

        ds_DisplayAssociateHTFValues(oCreature, fThirst, fHunger, fFatigue);
    }
}

void ds_htf_TravelCostTimerExpirationF()
{
    object oCreature = OBJECT_SELF;

    float fatigueDrop = h2_GetFatigueDecrement();
    float fDecrement = ds_ModifyFatigueDecrementUnit(oCreature, fatigueDrop);

    h2_PerformFatigueCheck(oCreature, fDecrement);

    if(!GetIsPC(oCreature) && !GetIsDM(oCreature) && GetIsPC(GetMaster(oCreature)))
    {
        float fThirst = GetLocalFloat(oCreature, H2_HT_CURR_THIRST) * 100.0;
        float fHunger = GetLocalFloat(oCreature, H2_HT_CURR_HUNGER) * 100.0;
        float fFatigue = GetLocalFloat(oCreature, H2_CURR_FATIGUE) * 100.0;

        ds_DisplayAssociateHTFValues(oCreature, fThirst, fHunger, fFatigue);
    }
}