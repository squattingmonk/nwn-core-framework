/*******************************************************************************
* Description:  Area Travel Timer consumption script
  Usage:        This script will be called when the Area Travel Timer expires.

********************************************************************************
* Created By:   tinygiant
* Created On:   20200125
*******************************************************************************/

#include "h2_fatigue_i"
#include "h2_hungerthrst_i"
#include "ds_htf_i"

//The primary purpose of this script is to apply the Area Travel Cost to the player's
//  HTF stats.  Once the travel cost is applied, the Area Travel Time is destroyed
//  to ensure the Travel Cost is not incurred a second time in the same area on the same
//  visit.
void main()
{
    object oCreature = OBJECT_SELF;

    //Set a flag to let our custom decrement modificaton function know if we're looking
    //  for an area travel cost or allowing the function to work normally.
    SetLocalInt(oCreature, DKSN_HTF_VARIABLE_COSTTRIGGER, TRUE);

    float fatigueDrop = ds_ModifyFatigueDecrementUnit(oCreature, 0.0);
    float thirstDrop = ds_ModifyThirstDecrementUnit(oCreature, 0.0);
    float hungerDrop = ds_ModifyHungerDecrementUnit(oCreature, 0.0);

    DeleteLocalInt(oCreature, DKSN_HTF_VARIABLE_COSTTRIGGER);

    h2_PerformFatigueCheck(oCreature, fatigueDrop);
    h2_PerformHungerThirstCheck(oCreature, thirstDrop, hungerDrop);

    SetLocalString(oCreature, DKSN_HTF_LAST_TRAVEL_COST_PAID, GetTag(GetArea(oCreature)));
    ds_DestroyAreaTravelTimer(oCreature);
}
