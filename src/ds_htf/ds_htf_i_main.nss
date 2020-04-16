/*******************************************************************************
* Description:  Add-on functions for the HCR ruleset, specifically created for
                the Dark Sun module.
  Usage:        Include in scripts where these add-on functions will be called.
********************************************************************************
* Created By:   Melanie Graham (Nairn)
* Created On:   2019-04-13
*******************************************************************************/

#include "ds_htf_i_const"
#include "ds_htf_i_config"
#include "ds_htf_i_text"

#include "ds_i_const"
#include "pw_i_core"

//Creates a timer on the PC object using the modified HCR2 timer functions.  The timer duration
//  is set as DS_HTF_AREATRAVELCOST_DELAY in ds_htf_c.
void ds_CreateAreaTravelTimer(object oPC);

//Destroy the timer created by ds_CreateAreaTravelTimer.
void ds_DestroyAreaTravelTimer(object oPC);

//Functions to modify the various decrement units based on custom factors such as race,
//  time of day, etc.  Can be expanded to do almost anything.  Will only be called if
//  DS_USE_CUSTOM_DECREMENT_FACTORS in ds_htf_c is set to TRUE.
float ds_ModifyFatigueDecrementUnit(object oPC, float fDecrement);
float ds_ModifyThirstDecrementUnit(object oPC, float fDecrement);
float ds_ModifyHungerDecrementUnit(object oPC, float fDecrement);

//Calculates and displays HTF values for associates of any non-DM PC.
void ds_DisplayAssociateHTFValues(object oCreature, float fThirst, float fHunger, float fFatigue);

//Looks up the area travel costs based on the type of area the PC is travelling in.  The area types
//  are held in a variable on the area object.  This is a holdover from how the system was
//  previously implemented.  If this behavior is not desired, this can be easily modified to use a set
//  value.  The area type constants are DS_AREATYPE_* in ds_constants_i.
int ds_GetAreaTravelCost(int iAreaType);

//Looks up the custom area travel message as a text constant DS_AREATRAVELMESSAGE_* in ds_constants_i.
string ds_GetAreaTravelMessage(int iAreaType);

//Currently disabled due to circular reference I didn't have time to fix.  The hook into the HCR2 is amateur
//  at best, which is causing this circular reference.  I'll have to code a better hook to we don't have to
//  worry about the compilation problems.
void ds_SearchForWater(object oPC, int iAreaType);

//Internal function to calculate the Travel Cost unit in place of a normal HTF decrement
//  unit.  Called only from dsModify***DecrementUnit functions.  No error checking, do not
//  call from outside of this include file.
float _calculateTravelCostUnit(object oCreature)
{
    int nAreaType = GetLocalInt(GetArea(oCreature), DS_HTF_VARIABLE_AREATYPE);
    int nCost = ds_GetAreaTravelCost(nAreaType);

    return IntToFloat(nCost)/100.0;
}

void ds_CreateAreaTravelTimer(object oPC)
{
    int timerID = h2_CreateTimer(oPC, DS_HTF_AREATIMER_SCRIPT, DS_HTF_AREATRAVELCOST_DELAY, FALSE, 1);
    SetLocalInt(oPC, DS_HTF_VARIABLE_AREATIMER, timerID);
    h2_StartTimer(timerID);
}

void ds_DestroyAreaTravelTimer(object oPC)
{
    int timerID = GetLocalInt(oPC, DS_HTF_VARIABLE_AREATIMER);
    DeleteLocalInt(oPC, DS_HTF_VARIABLE_AREATIMER);
    h2_KillTimer(timerID);
}

float ds_ModifyFatigueDecrementUnit(object oCreature, float fDecrement)
{
    if (GetLocalInt(oCreature, DS_HTF_VARIABLE_COSTTRIGGER) == TRUE) {
        fDecrement = _calculateTravelCostUnit(oCreature);
        return fDecrement;
    }

    if (GetRacialType(oCreature) == DS_RACIAL_TYPE_THRIKREEN) fDecrement = fDecrement * DS_FATIGUE_MULTIPLIER_THRIKREEN;
    if (GetRacialType(oCreature) == DS_RACIAL_TYPE_MUL)       fDecrement = fDecrement * DS_FATIGUE_MULTIPLIER_MUL;
    return fDecrement;
}

float ds_ModifyThirstDecrementUnit(object oCreature, float fDecrement)
{
    if (GetLocalInt(oCreature, DS_HTF_VARIABLE_COSTTRIGGER) == TRUE) {
        fDecrement = _calculateTravelCostUnit(oCreature);
        return fDecrement;
    }

    if ((GetTimeHour() >= DS_HOUR_START_HEAT) &&
        (GetTimeHour() <  DS_HOUR_STOP_HEAT)  &&
        (GetLocalInt(GetArea(oCreature), DS_HTF_VARIABLE_AREATYPE) > 0)) {
            fDecrement = fDecrement * DS_THIRST_MULTIPLIER_HEAT;
    }

    if (GetRacialType(oCreature) == DS_RACIAL_TYPE_HALFGIANT)  fDecrement = fDecrement * DS_THIRST_MULTIPLIER_HALFGIANT;
    return fDecrement;
}

float ds_ModifyHungerDecrementUnit(object oCreature, float fDecrement)
{
    if (GetLocalInt(oCreature, DS_HTF_VARIABLE_COSTTRIGGER) == TRUE) {
        fDecrement = _calculateTravelCostUnit(oCreature);
        return fDecrement;
    }
    if (GetRacialType(oCreature) == DS_RACIAL_TYPE_HALFGIANT)  fDecrement = fDecrement * DS_HUNGER_MULTIPLIER_HALFGIANT;
    return fDecrement;
}

//Internal function to create colored HTF bars for use in displaying HTF values on associates.  No error
//  checking, do not call from outside this include file.
string _createAssociateHTFBar(int nValue)
{
    int nMultiple = 100/GetStringLength(DS_HTF_BARS);

    int nBreakPoint = ((nValue + nMultiple/2)/nMultiple);
    string greenBar = h2_ColorText(GetSubString(DS_HTF_BARS, 0, nBreakPoint), H2_COLOR_GREEN);
    string redBar = h2_ColorText(GetSubString(DS_HTF_BARS, nBreakPoint, GetStringLength(DS_HTF_BARS)-nBreakPoint), H2_COLOR_RED);

    return greenBar + redBar;
}

void ds_DisplayAssociateHTFValues(object oCreature, float fThirst, float fHunger, float fFatigue)
{
    if (GetIsPC(oCreature) || GetIsDM(oCreature) || GetAssociateType(oCreature) == ASSOCIATE_TYPE_NONE) return;
    if (!H2_USE_HUNGERTHIRST_SYSTEM && !H2_USE_FATIGUE_SYSTEM) return;
     
    int currThirst = FloatToInt(fThirst);
    int currHunger = FloatToInt(fHunger);
    int currFatigue = FloatToInt(fFatigue);

    string sOpen = h2_ColorText(DS_TEXT_BRACKET_L, H2_COLOR_WHITE);
    string sClose = h2_ColorText(DS_TEXT_BRACKET_R, H2_COLOR_WHITE);
    string sDelimiter = h2_ColorText(DS_TEXT_DELIMITER, H2_COLOR_WHITE);

    string sThirst = "T";
    string sHunger = "H";
    string sFatigue = "F";
    
    string sName;
    string sHTFBar;

    switch (DS_HTF_ASSOCIATE_DISPLAY_TYPE)
    {
        case ASSOCIATE_DISPLAY_NUMBERS:
            if (H2_USE_HUNGERTHRIST_SYSTEM)
            {
                sThirst += IntToString(currThirst);
                sHunger += IntToString(currHunger);
            }

            if (H2_USE_FATIGUE_SYSTEM)
                sFatigue += IntToString(currFatigue);
        case ASSOCIATE_DISPLAY_BARS:
        case ASSOCIATE_DISPLAY_LETTERS:
            if (H2_USE_HUNGERTHRIST_SYSTEM)
            {
                sThirst = currThirst > DS_HTF_THRESHHOLD_CAUTION ? h2_ColorText(sThirst, H2_COLOR_GREEN) : 
                            currThirst <= DS_HTF_THRESHHOLD_DIRE ? h2_ColorText(sThirst, H2_COLOR_RED) :
                                                                    h2_ColorText(sThirst, H2_COLOR_YELLOW);

                sHunger = currHunger > DS_HTF_THRESHHOLD_CAUTION ? h2_ColorText(sHunger, H2_COLOR_GREEN) : 
                            currHunger <= DS_HTF_THRESHHOLD_DIRE ? h2_ColorText(sHunger, H2_COLOR_RED) :
                                                                    h2_ColorText(sHunger, H2_COLOR_YELLOW);
            }

            if (H2_USE_FATIGUE_SYSTEM)
                sFatigue = currFatigue > DS_HTF_THRESHHOLD_CAUTION ? h2_ColorText(sFatigue, H2_COLOR_GREEN) : 
                                currFatigue <= DS_HTF_THRESHHOLD_DIRE ? h2_ColorText(sFatigue, H2_COLOR_RED) :
                                                                        h2_ColorText(sFatigue, H2_COLOR_YELLOW);

            sHTFBar = sOpen + 
                        H2_USE_HUNGERTHIRST_SYSTEM ? sHunger + " " + sDelimiter + " " + sThirst + " " : "" +
                        H2_USE_FATIGUE_SYSTEM ? sFatigue : "" + sClose;
            break;
        default:
            break;
    }

    if(DS_HTF_ASSOCIATE_DISPLAY_TYPE == ASSOCIATE_DISPLAY_BARS)
    {
        if (H2_USE_HUNGERTHIRST_SYSTEM)
        {
            sThirst = sThirst + _createAssociateHTFBar(currThirst) + " ";
            sHunger = sHunger + _createAssociateHTFBar(currHunger) + " ";
        }

        if (H2_USE_FATIGUE_SYSTEM)
            sFatigue = sFatigue + _createAssociateHTFBar(currFatigue);

        sHTFBar = H2_USE_HUNGERTHIRST_SYSTEM ? sHunger + sThirst : "" + H2_USE_FATIGUE_SYSTEM ? sFatigue : "";
        //sHTFBar = sHunger + sThirst + sFatigue;
    }

    if (sHTFBar != "") 
    {
        SetName(oCreature, "");
        sName = GetName(oCreature) + "\n" + sHTFBar;
        SetName(oCreature, sName);
    } else
        SetName(oCreature, "");
}

int ds_GetAreaTravelCost(int iAreaType)
{
    int iTravelCost = 0;

    switch (iAreaType)
    {
        case DS_AREATYPE_BOULDERFIELD:
            iTravelCost = DS_AREATRAVELCOST_BOULDERFIELD;
            break;
        case DS_AREATYPE_DUSTSINK:
            iTravelCost = DS_AREATRAVELCOST_DUSTSINK;
            break;
        case DS_AREATYPE_MOUNTAIN:
            iTravelCost = DS_AREATRAVELCOST_MOUNTAIN;
            break;
        case DS_AREATYPE_MUDFLAT:
            iTravelCost = DS_AREATRAVELCOST_MUDFLAT;
            break;
        case DS_AREATYPE_ROCKYBADLAND:
            iTravelCost = DS_AREATRAVELCOST_ROCKYBADLAND;
            break;
        case DS_AREATYPE_SALTFLAT:
            iTravelCost = DS_AREATRAVELCOST_SALTFLAT;
            break;
        case DS_AREATYPE_SALTMARSH:
            iTravelCost = DS_AREATRAVELCOST_SALTMARSH;
            break;
        case DS_AREATYPE_SANDYWASTE:
            iTravelCost = DS_AREATRAVELCOST_SANDYWASTE;
            break;
        case DS_AREATYPE_SCRUBPLAIN:
            iTravelCost = DS_AREATRAVELCOST_SCRUBPLAIN;
            break;
        case DS_AREATYPE_STONYBARREN:
            iTravelCost = DS_AREATRAVELCOST_STONYBARREN;
            break;
        default:
            iTravelCost = DS_AREATRAVELCOST_DEFAULT;
    }
    return iTravelCost;
}

string ds_GetAreaTravelMessage(int iAreaType)
{
    string sMessage = "";

    switch (iAreaType)
    {
        case DS_AREATYPE_BOULDERFIELD:
            sMessage = DS_AREATRAVELMESSAGE_BOULDERFIELD;
            break;
        case DS_AREATYPE_DUSTSINK:
            sMessage = DS_AREATRAVELMESSAGE_DUSTSINK;
            break;
        case DS_AREATYPE_MOUNTAIN:
            sMessage = DS_AREATRAVELMESSAGE_MOUNTAIN;
            break;
        case DS_AREATYPE_MUDFLAT:
            sMessage = DS_AREATRAVELMESSAGE_MUDFLAT;
            break;
        case DS_AREATYPE_ROCKYBADLAND:
            sMessage = DS_AREATRAVELMESSAGE_ROCKYBADLAND;
            break;
        case DS_AREATYPE_SALTFLAT:
            sMessage = DS_AREATRAVELMESSAGE_SALTFLAT;
            break;
        case DS_AREATYPE_SALTMARSH:
            sMessage = DS_AREATRAVELMESSAGE_SALTMARSH;
            break;
        case DS_AREATYPE_SANDYWASTE:
            sMessage = DS_AREATRAVELMESSAGE_SANDYWASTE;
            break;
        case DS_AREATYPE_SCRUBPLAIN:
            sMessage = DS_AREATRAVELMESSAGE_SCRUBPLAIN;
            break;
        case DS_AREATYPE_STONYBARREN:
            sMessage = DS_AREATRAVELMESSAGE_STONYBARREN;
            break;
        default:
            sMessage = DS_AREATRAVELMESSAGE_DEFAULT;
    }
    return sMessage;
}

void ds_SaveLastFindWaterTime(object oPC)
{
    int findWaterTime = h2_GetSecondsSinceServerStart();
    string uniquePCID = h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID);
    h2_SetModLocalInt(uniquePCID + DS_HTF_VARIABLE_LAST_PC_FINDWATER_TIME, findWaterTime);
}

void ds_SearchForWater(object oPC, int iAreaType)
{/*
    int iAreaTravelCost = ds_GetAreaTravelCost(iAreaType);
    int nWaterPresent = Random(100);
    float fFailureChance = iAreaTravelCost * 2.0 / 15.0;

    ///Skill check to search for water
    int iSkillRoll = h2_SkillCheck(SKILL_TUMBLE, oPC, 2);

    if (iSkillRoll > 10)
    {
        // Test to see if there is water available to be found.
        if (fFailureChance > IntToFloat(nWaterPresent))
        {
            SendMessageToPC(oPC, DS_TEXT_NO_WATER_TO_BE_FOUND);
        }
        // If successful, display message and give "water" to the PC
        else
        {

            // Determine how much water the PC actually found based on skill check and area type
            int iWaterFound = (iAreaTravelCost + iSkillRoll) / 33;

            if (iWaterFound > 0)
            {
                // Success Message
                SendMessageToPC(oPC, DS_TEXT_PC_FIND_WATER_PREFIX + IntToString(iWaterFound) + DS_TEXT_PC_FIND_WATER_SUFFIX);

                // Get the first item in the player's inventory. It's likely not a canteen, but it could be!
                // We have to cycle through all the inventory items because the player might be carrying
                // multiple canteens and no one at Bioware or Beamdog has been thoughtful enough
                // to help us grab the Nth instance of an item in a player's pack
                object oCanteen = GetFirstItemInInventory(oPC);
                int iCanteenSpace = GetLocalInt(oCanteen, H2_HT_MAX_CHARGES) - GetLocalInt(oCanteen, H2_HT_CURR_CHARGES);
                int iCanteenFound = FALSE;

                while ((oCanteen != OBJECT_INVALID) && (iWaterFound != 0))
                {
                    if ((GetTag(oCanteen) == DS_ITEMTAG_CANTEEN) && (iCanteenSpace > 0))
                    {
                        iCanteenFound = TRUE;

                        if (iWaterFound > iCanteenSpace)
                        {
                            SetLocalInt(oCanteen, H2_HT_CURR_CHARGES, iCanteenSpace);
                            iWaterFound = iWaterFound - iCanteenSpace;
                        }
                        else
                        {
                            SetLocalInt(oCanteen, H2_HT_CURR_CHARGES, iWaterFound);
                            iWaterFound = 0;
                        }
                    }

                    GetNextItemInInventory(oPC);
                    iCanteenSpace = GetLocalInt(oCanteen, H2_HT_MAX_CHARGES) - GetLocalInt(oCanteen, H2_HT_CURR_CHARGES);
                }
                // If the PC has canteens but not enough space for all the water, fill them, and tell the PC how much water they are wasting
                if ((iWaterFound > 0) && (iCanteenFound = TRUE))
                {
                    SendMessageToPC(oPC, DS_TEXT_CANTEEN_FULL_PREFIX + IntToString(iWaterFound) + DS_TEXT_CANTEEN_FULL_SUFFIX);
                }
                // If the PC doesn't have any canteens, tell them how dumb that was and that the water was wasted
                if (iCanteenFound = FALSE)
                {
                    SendMessageToPC(oPC, DS_TEXT_CANTEEN_NOT_FOUND_PREFIX + IntToString(iWaterFound) + DS_TEXT_CANTEEN_NOT_FOUND_SUFFIX);
                }
            }
            else
            {
                SendMessageToPC(oPC, DS_TEXT_NO_WATER_TO_BE_FOUND);
            }
        }
    }

    //If failure, send failure message
    else {
       SendMessageToPC(oPC, DS_TEXT_PC_FAILED_TO_FIND_WATER);
    }*/
}

void _initAssociate(object oAssociate)
{
    if(!GetIsPC(oAssociate) && GetIsPC(GetMaster(oAssociate)))
    {    
        h2_InitFatigueCheck(oAssociate);
        h2_InitHungerThirstCheck(oAssociate);

        float fThirst = GetLocalFloat(oAssociate, H2_HT_CURR_THIRST) * 100.0;
        float fHunger = GetLocalFloat(oAssociate, H2_HT_CURR_HUNGER) * 100.0;
        float fFatigue = GetLocalFloat(oAssociate, H2_CURR_FATIGUE) * 100.0;

        ds_DisplayAssociateHTFValues(oAssociate, fThirst, fHunger, fFatigue);
    }
}

void ds_htf_AddAssociate()
{
    object oAssociate = OBJECT_SELF;
    
    if(GetIsPC(GetMaster(oAssociate)))
        DelayCommand(0.2, _initAssociate(oAssociate));
}