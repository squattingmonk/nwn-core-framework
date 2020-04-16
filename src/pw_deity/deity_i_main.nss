// -----------------------------------------------------------------------------
//    File: unid_i_main.nss
//  System: UnID Item on Drop (core)
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

#include "pw_i_core"
#include "deity_i_config"
#include "deity_i_const"
#include "deity_i_text"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< h2_DeityRez >---
// If a PC is ressurected by his deity, this function resets all approriate
//  PC variables and send the PC to the deity ressurection waypoint.
void h2_DeityRez(object oPC);

// ---< h2_CheckForDeityRez >---
// This function will determine whether the PC will be resurrected by their
//  diety.
int h2_CheckForDeityRez(object oPC);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void h2_DeityRez(object oPC)
{
    string deity = GetDeity(oPC);
    effect eRes = EffectResurrection();
    effect eHeal = EffectHeal(GetMaxHitPoints(oPC));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eRes, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
    h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_ALIVE);
    SendMessageToPC(oPC, H2_TEXT_DEITY_REZZED);
    string deityRez = GetName(oPC) + "_" + GetPCPlayerName(oPC) + H2_TEXT_DM_DEITY_REZZED + GetDeity(oPC);
    WriteTimestampedLogEntry(deityRez);
    SendMessageToAllDMs(deityRez);
    object deitywp = GetObjectByTag("WP_" + deity);
    if (GetIsObjectValid(deitywp))
    {
        AssignCommand(oPC, JumpToLocation(GetLocation(deitywp)));
        return;
    }
    deitywp = GetObjectByTag(H2_GENERAL_DEITY_REZ_WAYPOINT);
    if (GetIsObjectValid(deitywp))
    {
        AssignCommand(oPC, JumpToLocation(GetLocation(deitywp)));
        return;
    }
    location loc = GetLocalLocation(oPC, H2_LOCATION_LAST_DIED);
    AssignCommand(oPC, JumpToLocation(loc));
}

int h2_CheckForDeityRez(object oPC)
{
    string deity = GetDeity(oPC);
    if (deity == "" || deity == "NONE")
        return FALSE;

    float totalpercent  = (H2_BASE_DEITY_REZ_CHANCE + (GetHitDice(oPC) * H2_DEITY_REZ_CHANCE_PER_LEVEL));
    totalpercent = totalpercent * 10.0;
    int random = Random(1000);
    SendMessageToPC(oPC, IntToString(FloatToInt(totalpercent)) + " " + IntToString(random));
    if (FloatToInt(totalpercent) > Random(1000))
        return TRUE;
    SendMessageToPC(oPC, H2_TEXT_DEITY_NO_REZ);
    return FALSE;
}
