// -----------------------------------------------------------------------------
//    File: fugue_i_events.nss
//  System: Fugue Death and Resurrection (events)
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

 #include "fugue_i_main"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< fugue_OnClientEnter >---
// If the player is dead, but is not in the fugue or at his deity's ressurection 
//  location, send them to the fugue.
void fugue_OnClientEnter();

// ---< fugue_OnPlayerDeath >---
// Upon death, drop all henchmen and send PC to the fugue plane.
void fugue_OnPlayerDeath();

// ---< fugue_OnPlayerDying >---
// When a PC is dying, and already in the fugue plane, resurrect.
void fugue_OnPlayerDying();

// ---< fugue_OnPlayerExit >---
// No matter how a player exits the fugue plane, mark PC as alive.
void fugue_OnPlayerExit();

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void fugue_OnClientEnter()
{
    object oPC = GetEnteringObject();
    int playerstate = h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE);
    string uniquePCID = h2_GetPlayerPersistentString(oPC, H2_UNIQUE_PC_ID);
    location ressLoc = h2_GetExternalLocation(uniquePCID + H2_RESS_LOCATION);
    if (GetTag(GetArea(oPC)) != H2_FUGUE_PLANE && playerstate == H2_PLAYER_STATE_DEAD && !h2_GetIsLocationValid(ressLoc))
    {
        DelayCommand(H2_CLIENT_ENTER_JUMP_DELAY, h2_SendPlayerToFugue(oPC));
    }
}

void fugue_OnPlayerDeath()
{
    object oPC = GetLastPlayerDied();

    //if some other death subsystem set the player state back to alive before this one, no need to continue
    if (h2_GetPlayerPersistentInt(oPC, H2_PLAYER_STATE) != H2_PLAYER_STATE_DEAD)
        return;  //<-- Use core-framework cancellation function?

    if (GetTag(GetArea(oPC)) == H2_FUGUE_PLANE)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
        return;
    }
    else
    {
        h2_DropAllHenchmen(oPC);
        h2_SendPlayerToFugue(oPC);
    }
}

void fugue_OnPlayerDying()
{
    object oPC = GetLastPlayerDying();
    if (GetTag(GetArea(oPC)) == H2_FUGUE_PLANE)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);
        return;
    }
}

void fugue_OnPlayerExit()
{
    object oPC = GetExitingObject();
    DeleteLocalInt(oPC, H2_LOGIN_DEATH);
    h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_ALIVE);
}
