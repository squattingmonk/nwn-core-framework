// -----------------------------------------------------------------------------
//    File: bleed_i_main.nss
//  System: Bleed Persistent World Subsystem (core)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Primary functions for PW Subsystem
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

#include "pw_i_core"
#include "bleed_i_const"
#include "bleed_i_config"
#include "bleed_i_text"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

//Creates and starts a timer to track the bleeding of oPC.
void h2_BeginPlayerBleeding(object oPC);

//Makes the player oPC fully recover from a dying or stable state.
//This brings oPC to 1 HP and sets their player state to H2_PLAYER_STATE_ALIVE.
void h2_MakePlayerFullyRecovered(object oPC);

//Sets oPC's player state to H2_PLAYER_STATE_STABLE if oPC's player state was H2_PLAYER_STATE_DYING
//or makes oPC fully recovered if the oPC's player state was H2_PLAYER_STATE_STABLE
//and bDoFullRecovery is TRUE.
void h2_StabilizePlayer(object oPC, int bDoFullRecovery = FALSE);

//Causes bleed damage to oPC.
void h2_DoBleedDamageToPC(object oPC);

//Checks to see if oPC was able to stabilize on their own, if not
//bleed damage is done to oPC.
void h2_CheckForSelfStabilize(object oPC);

//Handles when the healing skill widget is used on a target.
void h2_UseHealWidgetOnTarget(object oTarget);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void h2_BeginPlayerBleeding(object oPC)
{
    int nCurrentHitPoints = GetCurrentHitPoints(oPC);
    SetLocalInt(oPC, H2_LAST_HIT_POINTS, nCurrentHitPoints);
    int timerID = CreateTimer(oPC, H2_BLEED_ON_TIMER_EXPIRE, H2_BLEED_DELAY);
    //int timerID = h2_CreateTimer(oPC, H2_BLEED_TIMER_SCRIPT, H2_BLEED_DELAY);
    SetLocalInt(oPC, H2_BLEED_TIMER_ID, timerID);
    StartTimer(timerID, TRUE);
    //h2_StartTimer(timerID);
}

void h2_MakePlayerFullyRecovered(object oPC)
{
    int nCurrHitPoints = GetCurrentHitPoints(oPC);
    if (nCurrHitPoints <= 0)
    {
        effect eHeal = EffectHeal(1 - nCurrHitPoints);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
    }
    SendMessageToPC(oPC,  H2_TEXT_RECOVERED_FROM_DYING);
    DeleteLocalInt(oPC, H2_TIME_OF_LAST_BLEED_CHECK);
    h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_ALIVE);
    //TODO: make monsters go hostile to PC again?
}

void h2_StabilizePlayer(object oPC, int bNaturalHeal = FALSE)
{
    int nPlayerState = h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE);
    int nCurrentHitPoints = GetCurrentHitPoints(oPC);
    SetLocalInt(oPC, H2_LAST_HIT_POINTS, nCurrentHitPoints);
    if (nPlayerState == H2_PLAYER_STATE_DYING)
    {
        SendMessageToPC(oPC,  H2_TEXT_PLAYER_STABLIZED);
        if (bNaturalHeal)
            h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_STABLE);
        else
            h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_RECOVERING);
        int timeOfBleedCheck = h2_GetSecondsSinceServerStart();
        SetLocalInt(oPC, H2_TIME_OF_LAST_BLEED_CHECK, timeOfBleedCheck);
    }
    else if (bNaturalHeal)
    {
        h2_MakePlayerFullyRecovered(oPC);
    }
    else
        h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_RECOVERING);
}

void h2_DoBleedDamageToPC(object oPC)
{
    int timeOfBleedCheck = h2_GetSecondsSinceServerStart();
    SetLocalInt(oPC, H2_TIME_OF_LAST_BLEED_CHECK, timeOfBleedCheck);
    int nCurrentHitPoints = GetCurrentHitPoints(oPC);
    SetLocalInt(oPC, H2_LAST_HIT_POINTS, nCurrentHitPoints);
    int nPlayerState = h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE);
    if (nPlayerState == H2_PLAYER_STATE_RECOVERING)
        return;
    switch(d6())
    {
        case 1: PlayVoiceChat(VOICE_CHAT_HELP, oPC); break;
        case 2: PlayVoiceChat(VOICE_CHAT_PAIN1, oPC); break;
        case 3: PlayVoiceChat(VOICE_CHAT_PAIN2, oPC); break;
        case 4: PlayVoiceChat(VOICE_CHAT_PAIN3, oPC); break;
        case 5: PlayVoiceChat(VOICE_CHAT_HEALME, oPC); break;
        case 6: PlayVoiceChat(VOICE_CHAT_NEARDEATH, oPC); break;
    }
    SendMessageToPC(oPC, H2_TEXT_WOUNDS_BLEED);
    effect eBloodloss = EffectDamage(H2_BLEED_BLOOD_LOSS, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eBloodloss, oPC);
}

void h2_CheckForSelfStabilize(object oPC)
{
    int nPlayerState = h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE);
    int stabilizechance = H2_SELF_STABILIZE_CHANCE;
    if (nPlayerState == H2_PLAYER_STATE_STABLE || nPlayerState == H2_PLAYER_STATE_RECOVERING)
        stabilizechance = H2_SELF_RECOVERY_CHANCE;

    int lastCheck = GetLocalInt(oPC, H2_TIME_OF_LAST_BLEED_CHECK);
    int secondsSinceLastCheck = h2_GetSecondsSinceServerStart() - lastCheck;
    if (nPlayerState == H2_PLAYER_STATE_DYING || secondsSinceLastCheck >= FloatToInt(H2_STABLE_DELAY))
    {
        if (d100() <= stabilizechance)
            h2_StabilizePlayer(oPC, TRUE);
        else
            h2_DoBleedDamageToPC(oPC);
    }
}

void h2_UseHealWidgetOnTarget(object oTarget)
{
    object oUser = GetItemActivator();
    int rollResult;
    if (GetIsPC(oTarget))
    {
        if (oTarget == oUser)
        {
            SendMessageToPC(oUser, H2_TEXT_CANNOT_USE_ON_SELF);
            return;
        }
        int nPlayerState = h2_GetPlayerPersistentInt(oTarget, H2_PLAYER_STATE);
        switch (nPlayerState)
        {
            case H2_PLAYER_STATE_DEAD:
                SendMessageToPC(oUser, H2_TEXT_CANNOT_RENDER_AID);
                break;
            case H2_PLAYER_STATE_DYING:
            case H2_PLAYER_STATE_STABLE:
                rollResult = h2_SkillCheck(SKILL_HEAL, oUser);
                if (rollResult >= H2_FIRST_AID_DC)
                {
                    h2_SetPlayerPersistentInt(oTarget, H2_PLAYER_STATE, H2_PLAYER_STATE_RECOVERING);
                    SendMessageToPC(oTarget,  H2_TEXT_PLAYER_STABLIZED);
                    SendMessageToPC(oUser, H2_TEXT_FIRST_AID_SUCCESS);
                }
                else
                    SendMessageToPC(oUser, H2_TEXT_FIRST_AID_FAILED);
                break;
            case H2_PLAYER_STATE_RECOVERING:
                SendMessageToPC(oUser, H2_TEXT_ALREADY_TENDED);
                break;
            case H2_PLAYER_STATE_ALIVE:
                if (GetCurrentHitPoints(oTarget) >= GetMaxHitPoints(oTarget))
                {
                    SendMessageToPC(oUser, H2_TEXT_DOES_NOT_NEED_AID);
                    return;
                }
                rollResult = h2_SkillCheck(SKILL_HEAL, oUser, 0);
                if (rollResult >= H2_LONG_TERM_CARE_DC)
                    SetLocalInt(oTarget, H2_LONG_TERM_CARE, 1);
                SendMessageToPC(oUser, H2_TEXT_ATTEMPT_LONG_TERM_CARE);
                SendMessageToPC(oTarget, H2_TEXT_RECEIVE_LONG_TERM_CARE);
                break;
        }
    }
    else //Target was not a PC, just Roll result and let DM decide what happens
        h2_SkillCheck(SKILL_HEAL, oUser);
}
