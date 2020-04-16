// -----------------------------------------------------------------------------
//    File: corpse_i_config.nss
//  System: PC Corpse (configuration)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Configuration File for PW Subsystem.
// -----------------------------------------------------------------------------
// Builder Use:
//  Set the variables below as directed in the comments for each variable.
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

//User defined event number sent to an NPC when a corpse token is activated on them.
//Pick any integer value that is not being used for another event number.
const int H2_PCCORPSE_ITEM_ACTIVATED_EVENT_NUMBER = 2147483500;

//Can be TRUE or FALSE.
//Set this to FALSE if you do not want to allow PC's to ressurect a corpse token at all.
//Default value is TRUE.
const int H2_ALLOW_CORPSE_RESS_BY_PLAYERS = TRUE;

//Can be TRUE or FALSE.
//Set this to TRUE if you want the raised PC to endure the PHB XP loss upon being raised or ressurected.
const int H2_APPLY_XP_LOSS_FOR_RESS = TRUE;

//Can be TRUE or FALSE.
//Set this to TRUE if you want the caster to lose gold according to the amount the PHB says is required
//for the cast spell.
const int H2_REQUIRE_GOLD_FOR_RESS = TRUE;

//The cost in gold for the raise dead spell. (must be a positive value)
//This only applies if H2_REQUIRE_GOLD_COST_FOR_RESS = TRUE;
const int H2_GOLD_COST_FOR_RAISE_DEAD = 5000;

//The cost in gold for the ressurection spell. (must be a positive value)
//This only applies if H2_REQUIRE_GOLD_COST_FOR_RESS = TRUE;
const int H2_GOLD_COST_FOR_RESSURECTION = 10000;
