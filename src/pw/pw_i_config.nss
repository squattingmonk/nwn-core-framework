// -----------------------------------------------------------------------------
//    File: pw_i_core.nss
//  System: Persistent World Administration (configuration file)
//     URL: 
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------
// Persistent world configuration settings.  This scripts contains all of the
//  settings that control high-level pw functions.
// -----------------------------------------------------------------------------
// Builder Use.  This script is meant to be modified by the builder in order
//  to create the desired environment.  This is a high-level configuration file.
//  Configuration constant for subsystem are in the system-specific (plugin)
//  configuration files.
// -----------------------------------------------------------------------------
// Acknowledgment:
// This script is a copy of Edward Becks HCR2 script h2_core_c modified and renamed
//  to work under Michael Sinclair's (Squatting Monk) core-framework system and
//  for use in the Dark Sun Persistent World.  Some of the HCR2 constants
//  have been removed because they are duplicates from the core-framework.
// -----------------------------------------------------------------------------
// Revisions:
// -----------------------------------------------------------------------------

//The combined length of any player-controlled character's first and last name must
//  not exceed this value.  player-controlled characters include player-characters
//  and Dungeon Masters.  This check is accomplished before OnClientEnter hook scripts
//  are run.  If the name length exceeds this value, the player is booted.  If booted,
//  neither the OnClientEnter or OnClientLeave events are triggered.  The purpose of
//  this restriction is to prevent ultra-long-name-based message flood exploits.
//Default Value: 40
const int H2_MAX_LENGTH_PCNAME = 40;

//This value controls the number of slots on the server available for player characters.
//  Setting this number to a value greater than 0 and a value less that the maximum
//  allowed players on the server (nwserver) will allow "always available" DM slots.
//  If a player logs in and this value is exceeded, that player will be booted.  A value
//  of 0 means there are no reserved DM slots.  DM PCs do not count against this total.
//Default value: 0
const int H2_MAXIMUM_PLAYERS = 0;

//This value controls whether a non-DM PC's location is periodically saved.
//Default value: TRUE
const int H2_SAVE_PC_LOCATION = TRUE;

//Time in real seconds, this is the delay between client enter and jumping the entering 
//  PC to their last saved location, or any other location, after login.  Adjust this 
//  value based on the size or lag of the server.
//Default value: 5.0
const float H2_CLIENT_ENTER_JUMP_DELAY = 1.0;

//Time interval in real-world seconds between each location save for a PC.
//Default value: 180.0
const float H2_SAVE_PC_LOCATION_TIMER_INTERVAL = 0.0;

//Set the below to true to remove all starting equipment from a newly created character.
//Default value: FALSE
const int H2_STRIP_ON_FIRST_LOGIN = FALSE;

//Set this value to the interval duration in seconds that you want to export all characters.
//You should only change this value if you are using a server vault.
//Recommended settings are from 30.0 (seconds) to 300.0 (five minutes)
//depending on your server performance.
//Individual player exports also occur if this value is above 0 whenevr the player rests or levels up.
//The default value is 0.0.
const float H2_EXPORT_CHARACTERS_INTERVAL = 30.0;

//Set this to the number of registered characters (alive or dead) that you want the player
//to be allowed to play. When a player chooses to retire a character it becomes unregistered
//and they are no longer allowed to play that character. If a player created a character after
//they have already attained the maximum number of registered characters allowed, they
//will not be able to play that character and will be booted.
//If a player logs in with a retired character they will be booted.
//If the PC is booted both the client enter and client leave hook-in scripts will not run for that PC.
//A value of zero means there is no limit to the number of characters they can play.
//When this value is zero the option to retire a character doesn't display.
//The default value is 0.
const int H2_REGISTERED_CHARACTERS_ALLOWED = 0;

//Force the game clock to update itself each heartbeat (to fix clock update problem for large modules)
//Set this to true if your module has trouble with the clock updating to see if it helps.
//The default value is FALSE.
const int H2_FORCE_CLOCK_UPDATE = FALSE;

//Set this to TRUE if you want the login message that shows the current game date and time to the
//entering player to be in the format: DD/MM/YYYY HH:MM instead of MM/DD/YYYY HH:MM.
//The default value is FALSE.
const int H2_SHOW_DAY_BEFORE_MONTH_IN_LOGIN = FALSE;
