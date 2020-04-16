// -----------------------------------------------------------------------------
//    File: bleed_i_events.nss
//  System: Bleed Persistent World Subsystem (events)
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

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< bleed_OnClientEnter >---
// Library and event registered script for the module-level OnClientEnter
//  event.  This function ensures each entering player has a Heal Widget in
//  their inventory.
void bleed_OnClientEnter();

// ---< bleed_OnPlayerDeath >---
// Library and event registered script for the module-level OnPlayerDeath
//  event.  This function starts the bleed functions if the player is not dead.
void bleed_OnPlayerDeath();

// ---< bleed_OnPlayerRestStarted >---
// Library and event registered script for the module-level OnPlayerRestStarted
//  event.  This function sets the maximum amount of healing a PC can do.
void bleed_OnPlayerRestStarted();

// ---< bleed_OnPlayerDying >---
// Library and event registered script for the module-level OnPlayerDying
//  event.  This function marks the PC's state and starts the bleed system.
void bleed_OnPlayerDying();

// ---< bleed_healwidget >---
// Library registered script for tag-based sripting for the healwidget item.
void bleed_healwidget();

// ---< bleed_OnTimerExpire >---
// Event registered script that runs when the bleed timer expires.  This
//  function will apply additional damage, check for self-stabilization, or
//  kill the PC, as required by the bleen system and custom settings.
// Note: OnTimerExpire is not a framework event.
void bleed_OnTimerExpire();

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

// ----- Module Events -----

void bleed_OnClientEnter()
{
    object oPC = GetEnteringObject();
    object oHealWidget = GetItemPossessedBy(oPC, H2_HEAL_WIDGET);
    if (!GetIsObjectValid(oHealWidget))
        CreateItemOnObject(H2_HEAL_WIDGET, oPC);
}

void bleed_OnPlayerDeath()
{
    object oPC = OBJECT_SELF;
    if (h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE) != H2_PLAYER_STATE_DEAD)
        h2_BeginPlayerBleeding(oPC);
}

void bleed_OnPlayerRestStarted()
{
    object oPC = GetLastPCRested();
    if (GetLocalInt(oPC, H2_LONG_TERM_CARE) && h2_GetPostRestHealAmount(oPC) > 0)
    {
        DeleteLocalInt(oPC, H2_LONG_TERM_CARE);
        int postRestHealAmt = h2_GetPostRestHealAmount(oPC) * 2;
        h2_SetPostRestHealAmount(oPC, postRestHealAmt);
    }
}

void bleed_OnPlayerDying()
{
    object oPC = GetLastPlayerDying();
    if (h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE) == H2_PLAYER_STATE_DYING)
        h2_BeginPlayerBleeding(oPC);
}

// ----- Tag-based Scripting -----

void bleed_healwidget()
{
    int nEvent = GetUserDefinedItemEventNumber();

    // * This code runs when the Unique Power property of the item is used
    // * Note that this event fires PCs only
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oTarget = GetItemActivatedTarget();
        if (GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
            return;
        h2_UseHealWidgetOnTarget(oTarget);
    }
}

// ----- Timer Events -----

void bleed_OnTimerExpire()
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