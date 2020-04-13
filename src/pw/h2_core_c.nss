/*
Filename:           h2_core_c
System:             core (user configuration include script)
Author:             Edward Beck (0100010)
Date Created:       Aug. 28, 2005
Summary:
HCR2 core variable user-configuration variable settings.
This script is consumed by h2_core_i as an include directive.

This contains user definable toggles and settings for the core system.

This script is freely editable by the mod builder. It should not contain any h2 functions or constants
that should not be overrideable by the user, please put those in h2_core_i.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:  Jun 28th 2006
Revision Author: Edward Beck (0100010)
Revision Summary: v1.2
Added H2_EXPORT_CHARACTERS_ON_HEARTBEAT setting (default to FALSE)
Switched H2_REGISTERED_CHARACTERS_ALLOWED to default to 0 and Expanded comments.
Switched H2_STRIP_ON_FIRST_LOGIN to defaiult to FALSE.

*/

//You may swap the below #include "hc2_core_t"  text directives for an equivalant language specific
//one. (All variable names must match however for it to compile properly.)
#include "h2_core_t"

//All below functions and constants may be overriden by the user, but do not alter the function signature
//or the name of the constant.

//Begin user configurable constant declarations.

//The combined length of a PC's first and last names must not exceed
//the below value. If it does they are booted. (This affects DM names also)
//This check is done before any client enter hook-in scripts are run.
//If the PC is booted, both the client enter and client leave hook-in scripts will not run for that PC.
//This is to prevent ultra long name based message flood exploits.
//The default value is 40.
const int H2_MAX_LENGTH_PCNAME = 40;

//Set this value to a number less than or equal to the maximum number of players allowed
//on the server settings on nwserver. Each value less than the maximum allowed on the server
//settings provides one "always available" DM slot.
//If a non-dm player logs in, and this amount has been met or exceeded they will be booted.
//If the PC is booted, both the client enter and client leave hook-in scripts will not run for that PC.
//A value of zero or a value greater than or equal to the maximum number of players allowed on the
//server settings means no slots are reserved for the DMs.
//DMs do not count against this total, when number of player logged in is determined.
//The default value is 0.
const int H2_MAXIMUM_PLAYERS = 0;

//Set this to true to automatically save the PC's location periodically
//The default value is TRUE.
const int H2_SAVE_PC_LOCATION = TRUE;

//Time in real seconds, this is the delay between client enter and jumping the entering PC to their
//last saved location, or any other location after login,
//Adjust this value based on the size or lag of the server.
//The default value is 5.0.
const float H2_CLIENT_ENTER_JUMP_DELAY = 5.0;

//Time interval in real seconds between each location save for a PC. ie 180 = save location every 3 RL minutes.
const float H2_SAVE_PC_LOCATION_TIMER_INTERVAL = 180.0;

//Set the below to true to remove all starting equipment from a newly created character.
//The default value is FALSE.
const int H2_STRIP_ON_FIRST_LOGIN = FALSE;

//Set this value to the interval duration in seconds that you want to export all characters.
//You should only change this value if you are using a server vault.
//Recommended settings are from 30.0 (seconds) to 300.0 (fivew minutes)
//depending on your server performance.
//Individual player exports also occur if this value is above 0 whenevr the player rests or levels up.
//The default value is 0.0.
const float H2_EXPORT_CHARACTERS_INTERVAL = 0.0;

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

//Set this to the welcome message you want to be sent to all players (and DMs) that log into your module.
const string H2_TEXT_ON_LOGIN_MESSAGE = "Welcome to Dark Sun";

//Set this to true to indicate that you have read this file and made your adjustments to the above settings
//according to your module's needs. If this value is false all who login to the server will receive
//a message stating you have not altered it instead of the above H2_TEXT_ON_LOGIN_MESSAGE.
//The default value is FALSE.
const int H2_READ_CHECK = TRUE;

//End of user configurable constant declarations.
