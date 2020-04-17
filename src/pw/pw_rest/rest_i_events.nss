// -----------------------------------------------------------------------------
//    File: rest_i_events.nss
//  System: Rest (events)
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

#include "rest_i_main"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< rest_Canteen_OnTriggerEnter >---
// This function sets a variable on the PC upon entering a trigger associated
//  with refilling the PC's canteen.  To use, on the desired trigger, create a
//  string variable called OnTriggerEnter and set the value to
//  "rest_Canteen_OnTriggerEnter".
void rest_Canteen_OnTriggerEnter();

// ---< rest_Canteen_OnTriggerExit >---
// This function sets a variable on the PC upon exiting a trigger associated
//  with refilling the PC's canteen.  To use, on the desired trigger, create a 
//  string variable called OnTriggerExit and set the value to
//  "rest_Canteen_OnTriggerExit".
void rest_Canteen_OnTriggerExit();

// ---< rest_OnPlayerRestStarted >---
// This is an event function when the module-level OnPlayerRestStarted event
//  fires.  It is registered as a library and event script in rest_l_plugin.
//  This function ensure the PC meets all requirements to rest as set in the
//  Rest system configuration file.
void rest_OnPlayerRestStarted();

// ---< rest_OnPlayerRestFinished >---
// This is an event function when the module-level OnPlayerRestFinished event
//  fires.  It is registered as a library and event script in rest_l_plugin.
//  This function restores PC spells/feats and sets the PC up for the next
//  resting period.
void rest_OnPlayerRestFinished();

// ---< rest_OnPlayerRestCancelled >---
// This is an event function when the module-level OnPlayerRestCancelled event
//  fires.  It is registered as a library and event script in rest_l_plugin.
//  This function sets PC values upon rest cancellation and removes the sleep
//  effect.
void rest_OnPlayerRestCancelled();

// ---< rest_firewood >---
// Tag-based scripting function for using the rest system item h2_firewood.
void rest_firewood();

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

// ----- Module Events -----

void rest_OnPlayerRestStarted()
{
    object oPC = GetLastPCRested();
    int nRemainingTime = h2_RemainingTimeForRecoveryInRest(oPC);
    int skipDialog = GetLocalInt(oPC, H2_SKIP_REST_DIALOG);
    if (H2_REQUIRE_REST_TRIGGER_OR_CAMPFIRE)
    {
        object oRestTrigger = GetLocalObject(oPC, H2_REST_TRIGGER);
        object oCampfire = GetNearestObjectByTag(H2_CAMPFIRE, oPC);
        if (GetIsObjectValid(oRestTrigger))
        {
            if (GetLocalInt(oRestTrigger, H2_IGNORE_MINIMUM_REST_TIME))
                nRemainingTime = 0;
            string feedback = GetLocalString(oRestTrigger, H2_REST_FEEDBACK);
            if (feedback != "" && skipDialog)
                SendMessageToPC(oPC, feedback);
        }
        else if (!GetIsObjectValid(oCampfire) || GetDistanceBetween(oPC, oCampfire) > 4.0)
        {
            h2_SetAllowRest(oPC, FALSE);
            return;
        }
    }

    if (nRemainingTime != 0)
    {
        if (!skipDialog)
        {
            string waittime = FloatToString(nRemainingTime / HoursToSeconds(1), 5, 2);
            string message = H2_TEXT_RECOVER_WITH_REST_IN + waittime + H2_TEXT_HOURS;
            SendMessageToPC(oPC, message);
        }
        h2_SetAllowSpellRecovery(oPC, FALSE);
        h2_SetAllowFeatRecovery(oPC, FALSE);
        h2_SetPostRestHealAmount(oPC, 0);
    }
    else
    {
        if (skipDialog && H2_SLEEP_EFFECTS)
            h2_ApplySleepEffects(oPC);
        if (H2_HP_HEALED_PER_REST_PER_LEVEL > -1)
        {
            int postRestHealAmt = H2_HP_HEALED_PER_REST_PER_LEVEL * GetHitDice(oPC);
            h2_SetPostRestHealAmount(oPC, postRestHealAmt);
        }
    }
}

void rest_OnPlayerRestFinished()
{
    object oPC = GetLastPCRested();
    int bAllowSpellRecovery = h2_GetAllowSpellRecovery(oPC);
    if (!bAllowSpellRecovery)
        h2_SetAvailableSpellsToSavedValues(oPC);

    int bAllowFeatRecovery = h2_GetAllowFeatRecovery(oPC);
    if (!bAllowFeatRecovery)
        h2_SetAvailableSpellsToSavedValues(oPC);

    if (bAllowSpellRecovery && bAllowFeatRecovery)
        h2_SaveLastRecoveryRestTime(oPC);

    h2_LimitPostRestHeal(oPC, h2_GetPostRestHealAmount(oPC));
}

void rest_OnPlayerRestCancelled()
{
    object oPC = GetLastPCRested();
    h2_SetPlayerHitPointsToSavedValue(oPC);
    h2_SetAvailableSpellsToSavedValues(oPC);
    h2_SetAvailableFeatsToSavedValues(oPC);
    if (H2_SLEEP_EFFECTS)
        h2_RemoveEffectType(oPC, EFFECT_TYPE_BLINDNESS);
}

// ----- Tag-based Scripting ---

void rest_firewood()
{
    int nEvent = GetUserDefinedItemEventNumber();
    if (nEvent ==  X2_ITEM_EVENT_ACTIVATE)
    {
        object oPC   = GetItemActivator();
        object oItem = GetItemActivated();
        h2_UseFirewood(oPC, oItem);
    }
}

void rest_OnTriggerEnter()
{
    object oPC = GetEnteringObject();
    SetLocalObject(oPC, H2_REST_TRIGGER, OBJECT_SELF);
}

void rest_OnTriggerExit()
{
    object oPC = GetExitingObject();
    DeleteLocalObject(oPC, H2_REST_TRIGGER);
}