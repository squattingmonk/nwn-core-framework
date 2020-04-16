// -----------------------------------------------------------------------------
//    File: ds_htf_i_events.nss
//  System: Hunger Thirst Fatigue (Dark Sun) (events)
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

// #include "x_i_main"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

// ----- Module Events -----

//When entering an travel area, the PC may be required to pay a travel cost, which is borne by
//  a reducation in HTF capacity.  This script creates a timer on the entering object to allow
//  that to happen.  The purpose of waiting a designated interval is to ensure the PC didn't
//  enter the area on accident, thus allowing the PC to return to the previous area before the
//  timer expires and without incurring the travel cost.

//If the creature has paid a travel cost and then enters a populated area with no designated travel
//  cost, a timer is created to ensure the PC can return to the previous area in which the creature
//  already paid the travel cost without incurring another travel cost, as long as the PC returns
//  to that area before the timer expires.

void ds_htf_OnAreaEnter()
{
    object oCreature = GetEnteringObject();

    if (GetIsDM(oCreature)) return;

    int nAreaType = GetLocalInt(GetArea(oCreature), DS_HTF_VARIABLE_AREATYPE);
    string sAreaPaid = GetLocalString(oCreature, DS_HTF_LAST_TRAVEL_COST_PAID);

    if(GetIsPC(oCreature) && !nAreaType)
    {
        string sPCMessage = ds_GetAreaTravelMessage(nAreaType);
        if (sPCMessage != "") 
            SendMessageToPC(oCreature, sPCMessage);
    }

    if (sAreaPaid == GetTag(GetArea(oCreature))) 
    {
        ExecuteScript(DS_HTF_KILLTIMER_SCRIPT, oCreature);
        return;
    }

    if (ds_GetAreaTravelCost(nAreaType) > 0) ds_CreateAreaTravelTimer(oCreature);
        else if(sAreaPaid != "")
        {
            int nTimerID = CreateTimer(oCreature, DS_HTF_AREA_ON_TIMER_EXPIRE, DS_HTF_AREATRAVECOST_DELAY, 1, 0);
            //int nTimerID = h2_CreateTimer(oCreature, DS_HTF_KILLTIMER_SCRIPT, DS_HTF_AREATRAVELCOST_DELAY, FALSE, 1);
            SetLocalInt(oCreature, DS_HTF_VARIABLE_KILLTIMER, nTimerID);
            h2_StartTimer(nTimerID);
        }
}

//PCs entering non-populated areas may incur a travel cost.  This cost is charged through use
//  of a timer instantiated when a PC enters a travel area.  If the PC departs the travel area
//  before the timer expires, the PC is not charged for travelling in that area.  This function
//  kills the travel cost timer to ensure the PC is not charged.

void ds_htf_OnAreaExit()
{
    object oCreature = GetExitingObject();
    if (GetIsDM(oCreature)) return;

    int nAreaType = GetLocalInt(GetArea(oCreature), DS_HTF_VARIABLE_AREATYPE);
    
    if (GetLocalInt(oCreature, DS_HTF_VARIABLE_AREATIMER) > 0) ds_DestroyAreaTravelTimer(oCreature);
    if (GetLocalInt(oCreature, DS_HTF_VARIABLE_KILLTIMER) > 0) h2_KillTimer(GetLocalInt(oCreature, DS_HTF_VARIABLE_KILLTIMER));
}

// ----- Timer Events -----

//The primary purpose of this script is to apply the Area Travel Cost to the player's
//  HTF stats.  Once the travel cost is applied, the Area Travel Time is destroyed
//  to ensure the Travel Cost is not incurred a second time in the same area on the same
//  visit.
void ds_htf_area_OnTimerExpire()
{
    object oCreature = OBJECT_SELF;

    //Set a flag to let our custom decrement modificaton function know if we're looking
    //  for an area travel cost or allowing the function to work normally.
    SetLocalInt(oCreature, DS_HTF_VARIABLE_COSTTRIGGER, TRUE);

    float fatigueDrop = ds_ModifyFatigueDecrementUnit(oCreature, 0.0);
    float thirstDrop = ds_ModifyThirstDecrementUnit(oCreature, 0.0);
    float hungerDrop = ds_ModifyHungerDecrementUnit(oCreature, 0.0);

    DeleteLocalInt(oCreature, DS_HTF_VARIABLE_COSTTRIGGER);

    h2_PerformFatigueCheck(oCreature, fatigueDrop);
    h2_PerformHungerThirstCheck(oCreature, thirstDrop, hungerDrop);

    SetLocalString(oCreature, DS_HTF_LAST_TRAVEL_COST_PAID, GetTag(GetArea(oCreature)));
    ds_DestroyAreaTravelTimer(oCreature);
}

void ds_htf_KillTravelCostTimer()
{
    object oCreature = OBJECT_SELF;
    DeleteLocalString(oCreature, DS_HTF_LAST_TRAVEL_COST_PAID);
    h2_KillTimer(GetLocalInt(oCreature, DS_HTF_VARIABLE_KILLTIMER));
    DeleteLocalInt(oCreature, DS_HTF_VARIABLE_KILLTIMER);
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
