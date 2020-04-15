// -----------------------------------------------------------------------------
//    File: bleed_i_config.nss
//  System: Bleed Persistent World Subsystem (configuration)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Configuration values for PW Subsystem
// -----------------------------------------------------------------------------
// Builder Use:
//  Everything!  Set these values to work in your world!
// -----------------------------------------------------------------------------
// Acknowledgment:
// -----------------------------------------------------------------------------
//  Revision:
//      Date:
//    Author:
//   Summary:
// -----------------------------------------------------------------------------


//All below functions and constants may be overriden by the user, but do not alter the function signature
//or the name of the constant.
//Begin function and constant declarations.

//Amount of time in seconds between when the player character bleeds while dying.
//Note this is seconds in real time, not game time.
//Recommend value: 6 seconds (1 heartbeat/round)
const float H2_BLEED_DELAY = 6.0;

//Amount of time in seconds between when a stable player character nexts checks to see if they begin to recover.
//Note this is seconds in real time, not game time.
//Recommended Equation: [Minutes per game hour] * 60 seconds = HoursToSeconds(1).
float H2_STABLE_DELAY = HoursToSeconds(1);

//Percent chance a player character will self stabilize and stop bleedng when dying.
//Range of values is 0 - 100
//Recommended value: 10 (as per 3.5 rules giving 10% chance)
const int H2_SELF_STABILIZE_CHANCE = 10;

//Percent chance a player character will regain conciousness and begin recovery after self-stabilizing.
//Range of values is 0 - 100
//Recommended value: 10 (as per 3.5 rules giving 10% chance)
const int H2_SELF_RECOVERY_CHANCE = 10;

//Amount of hitpoints lost when a player character bleeds.
//Recomended value: 1
const int H2_BLEED_BLOOD_LOSS = 1;

//Heal check DC to provide first aid to a dying charcater to stablize them.
//Default value is 15.
const int H2_FIRST_AID_DC = 15;

//Heal check DC to provide long term care to an injured character.
//Default value is 15.
const int H2_LONG_TERM_CARE_DC = 15;
//End function and constant declarations.
