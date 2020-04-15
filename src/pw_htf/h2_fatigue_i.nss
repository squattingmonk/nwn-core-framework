/*
Filename:           h2_fatigue_i
System:             fatigue
Author:             Edward Beck (0100010)
Date Created:       Sept. 11th, 2006
Summary:
HCR2 h2_fatigue_i script.
This is an include script for the fatigue subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Dec 31st, 2006
Revision Author: 0100010
Revision Summary: v1.5
Adjusted code to deal with changes to timer functions.

Revision Date: 20200201
Revision Author: Edward Burke (tinygiant)
Revision Summary: v1.6
Modified h2_PerformFatigueCheck to allow a custom decrement unit to be passed.  The new argument is optional, so all
    legacy calls will still work with the code.  Additionally modified this function to prevent animation functions being
    sent to NPCs.
Modified the fatigue timer script HW_FATIGUE_TIMER_SCRIPT to ds_htf_ftimer to allow custom decrement unit processing.
Modified h2_DisplayFatigueInfoBar to exclude non-PCs because DS is using this system on NPCs with a custom HTF data display.
Modified h2_DoFatigueFortitudeCheck to prevent animation functions being sent to NPCs.
Added h2_GetFatigueDecrement so the base decrement forumula could be referenced from another script.
*/

#include "h2_fatigue_c"
#include "h2_core_i"
#include "x3_inc_string"

const string H2_CURR_FATIGUE = "H2_CURR_FATIGUE";
const string H2_IS_FATIGUED = "H2_IS_FATIGUED";
const string H2_FATIGUE_INFO_BAR = "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||";
const string H2_FATIGUE_EFFECTS = "H2_FATIGUE_EFFECTS";
//const string H2_FATIGUE_TIMER_SCRIPT = "h2_fatiguetimer";
const string H2_FATIGUE_TIMER_SCRIPT = "ds_htf_ftimer";
const string H2_FATIGUE_SAVE_COUNT = "H2_FATIGUE_SAVE_COUNT";

float h2_GetFatigueDecrement()
{
    return 1.0 / (H2_FATIGUE_HOURS_WITHOUT_REST);
}

void h2_DisplayFatigueInfoBar(object oPC)
{
    if(GetIsDM(oPC)) return;

    int fatigueCount = FloatToInt(GetLocalFloat(oPC, H2_CURR_FATIGUE) * 100.0);
    string greenBar = h2_ColorText(GetSubString(H2_FATIGUE_INFO_BAR, 0, fatigueCount), H2_COLOR_GREEN);
    string redBar = h2_ColorText(GetSubString(H2_FATIGUE_INFO_BAR, fatigueCount, 100 - fatigueCount), H2_COLOR_RED);
    SendMessageToPC(oPC, H2_TEXT_FATIGUE + greenBar + redBar);
}

void h2_InitFatigueCheck(object oPC)
{
    if (!GetLocalInt(oPC, H2_IS_FATIGUED) && GetLocalFloat(oPC, H2_CURR_FATIGUE) == 0.0)
        SetLocalFloat(oPC, H2_CURR_FATIGUE, 1.0);

    int timerID = h2_CreateTimer(oPC, H2_FATIGUE_TIMER_SCRIPT, HoursToSeconds(1), FALSE);
    //int timerID = h2_CreateTimer(oPC, H2_FATIGUE_TIMER_SCRIPT, 10.0, FALSE);
    h2_StartTimer(timerID);

    if (GetIsPC(oPC) && H2_FATIGUE_DISPLAY_INFO_BAR)
        h2_DisplayFatigueInfoBar(oPC);
}

void h2_DoFatigueFortitudeCheck(object oPC)
{
    SetLocalInt(oPC, H2_IS_FATIGUED, TRUE);
    int saveCount = GetLocalInt(oPC, H2_FATIGUE_SAVE_COUNT);
    if(GetIsPC(oPC)) 
    {
        SendMessageToPC(oPC, H2_TEXT_NEAR_COLLAPSE);
        AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED, 1.0, 2.0));
        PlayVoiceChat(VOICE_CHAT_REST, oPC);
    }

    int fortCheck = FortitudeSave(oPC, saveCount + 10);
    if (!fortCheck || saveCount >= 10)
    {
        effect eStrLoss = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_STRENGTH, 1));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStrLoss, oPC);
        effect eDexLoss = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_DEXTERITY, 1));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDexLoss, oPC);
        effect eMovement = ExtraordinaryEffect(EffectMovementSpeedDecrease(10));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMovement, oPC);
        if (saveCount >= 10 && !fortCheck)
        {
            if (GetRacialType(oPC) == RACIAL_TYPE_ELF || GetRacialType(oPC) == RACIAL_TYPE_HALFELF)
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectKnockdown()), oPC, 180.0);
            else
            {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectSleep()), oPC, 180.0);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectVisualEffect(VFX_IMP_SLEEP)), oPC, 180.0);
            }
            if(GetIsPC(oPC)) AssignCommand(oPC, SpeakString(H2_TEXT_COLLAPSE));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(EffectBlindness()), oPC, 180.0);
            SetLocalFloat(oPC, H2_CURR_FATIGUE, 0.33);
        }
    }
    SetLocalInt(oPC, H2_FATIGUE_SAVE_COUNT, saveCount + 1);
}

void h2_PerformFatigueCheck(object oPC, float fCustomFatigueDecrement = -1.0)
{
    if(GetIsDM(oPC)) return;

    if(GetIsPC(oPC))
        if (h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE) == H2_PLAYER_STATE_DEAD)
            return;

    float fatigueDrop = (fCustomFatigueDecrement >= 0.0) ? fCustomFatigueDecrement : h2_GetFatigueDecrement();

    float currFatigue = GetLocalFloat(oPC, H2_CURR_FATIGUE);
    if (currFatigue > 0.0)
        currFatigue = currFatigue - fatigueDrop;
    if (currFatigue < 0.0)
        currFatigue = 0.0;
    SetLocalFloat(oPC, H2_CURR_FATIGUE, currFatigue);
    
    if(GetIsPC(oPC))
    {
        if (H2_FATIGUE_DISPLAY_INFO_BAR)
            h2_DisplayFatigueInfoBar(oPC);

        if (currFatigue < 0.33 && currFatigue > 0.0)
        {
            SendMessageToPC(oPC, H2_TEXT_TIRED1);
            AssignCommand(oPC, SpeakString(H2_TEXT_YAWNS));
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED));
        }
    }

    if (currFatigue == 0.0)
        h2_DoFatigueFortitudeCheck(oPC);
    else
        DeleteLocalInt(oPC, H2_FATIGUE_SAVE_COUNT);
}
