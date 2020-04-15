// -----------------------------------------------------------------------------
//    File: rest_i_config.nss
//  System: Rest (configuration)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Description:
//  Configuration File for PW Subsystem.
// -----------------------------------------------------------------------------
// Builder Use:
//  Set the constants below as directed in the comments for each constant.
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

//Minimum Time in real seconds that must pass since the last time a PC rested and
//recovered spells, feats and health, for them to recover them again when they rest.
//Recommended Equation: [Minutes per game hour] * 60 * 8; (results in 8 game hours)
//The default value is 960, which is 8 game hours using 2 RL minutes per game hour.
//To not require any minimum elapsed time set the value to 0.
const int H2_MINIMUM_SPELL_RECOVERY_REST_TIME = 1440;

//Amount of hit points per level that is healed when resting after the minimum time above passed.
//The default value is 1.
//To allow PCs to heal to maximum hitpoints, set the value to -1.
//Note that some with rest event hook-in scripts may alter the final amount of HP healed after the rest
//to a value different than what would result from the value you specify below, even if the value is -1.
const int H2_HP_HEALED_PER_REST_PER_LEVEL = -1;

//Set this value to true to create a blindness and snoring visual effect on PCs who
//rest with recovery.
const int H2_SLEEP_EFFECTS = TRUE;

//Set this to true to only allow resting inside designated trigger zones
//or within 4 meters of a campfire.
const int H2_REQUIRE_REST_TRIGGER_OR_CAMPFIRE = FALSE;
