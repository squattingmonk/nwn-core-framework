// -----------------------------------------------------------------------------
//    File: bleed_i_timers.nss
//  System: Bleed Persistent World Subsystem (timers)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Timer functions for PW Subsystem
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

#include "bleed_i_main"

void bleedTimer_Expire()
{
    object oPC = OBJECT_SELF;
    int nPlayerState = h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE);
    if (nPlayerState != H2_PLAYER_STATE_DYING && nPlayerState != H2_PLAYER_STATE_STABLE &&
        nPlayerState != H2_PLAYER_STATE_RECOVERING)
    {
        int nTimerID = GetLocalInt(oPC, H2_BLEED_TIMER_ID);
        DeleteLocalInt(oPC, H2_BLEED_TIMER_ID);
        DeleteLocalInt(oPC, H2_TIME_OF_LAST_BLEED_CHECK);
        h2_KillTimer(nTimerID);
    }
    else
    {
        int nCurrHitPoints = GetCurrentHitPoints(oPC);
        if (nCurrHitPoints > 0)
        {
            h2_MakePlayerFullyRecovered(oPC);
            return;
        }
        int nLastHitPoints = GetLocalInt(oPC, H2_LAST_HIT_POINTS);
        if (nCurrHitPoints > nLastHitPoints)
        {
            h2_StabilizePlayer(oPC);
            return;
        }
        if (nCurrHitPoints > -10)
        {
            h2_CheckForSelfStabilize(oPC);
        }
        else
        {
            h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_DEAD);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
        }
    }
}