// -----------------------------------------------------------------------------
//    File: fugue_i_main.nss
//  System: Fugue Death and Resurrection (core)
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

// -----------------------------------------------------------------------------
//                                   Variables
// -----------------------------------------------------------------------------

#include "pw_i_core"
#include "fugue_i_config"
#include "fugue_i_const"
#include "fugue_i_text"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< _SendPlayerToFugue >---
// Upon player death, send the PC to the fugue plane and resurrect.
void h2_SendPlayerToFugue(object oPC);

// -----------------------------------------------------------------------------
//                              Function Definitions
// -----------------------------------------------------------------------------

void h2_SendPlayerToFugue(object oPC)
{
    object oFugueWP = GetObjectByTag(H2_WP_FUGUE);
    SendMessageToPC(oPC, H2_TEXT_YOU_HAVE_DIED);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
    h2_RemoveEffects(oPC);
    ClearAllActions();
    AssignCommand(oPC, JumpToObject(oFugueWP));
}
