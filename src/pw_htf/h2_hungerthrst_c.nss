/*
Filename:           h2_hungerthrst_c
System:             hunger and thirst
Author:             Edward Beck (0100010)
Date Created:       Sept. 4, 2006
Summary:
HCR2 h2_hungerthrst_c script.
This is a configuration script for the hunger and thirst subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

//You may swap the below #include "h2_hungerthrst_t"  text directives for an equivalant language specific
//one. (All variable names must match however for it to compile properly.)
#include "h2_hungerthrst_t"

//This value plus the base constitution score of a player, is the number
//of in-game hours they can go without drinking water with no chance of ill effects.
//After this time peroid is up, failing a DC 10 +(numer of previous checks) fortitude
//save causes them to become fatigued.
const int H2_HT_BASE_THIRST_HOURS = 24;

//This value is the base number of hours a player can go without eating food
//with no chance of ill effects.
//After this time period is up, failing a DC 10 +(number of previous checks) fortitude
//save, (which is made only once per 24 in-game hours) causes them to become fatigued.
const int H2_HT_BASE_HUNGER_HOURS = 72;

//Determines whether or not the info bars for displaying
//hunger and thirst levels  will be shown to the PC.
//These occur every in-game hour.
const int H2_HT_DISPLAY_INFO_BARS = TRUE;

//Set this value to the name of a script that you want to be executed
//if the PC's nonlethaldamage from hunger or thirst exceeds their max hitpoints.
//The script object will be the PC that is dehydrated and/or starving.
//Use this script to customize what effects you feel are appropriate for
//you module, be in uconciousness or death etc. Note that the PC
//will already be fatigued by the time they reach this point.
const string H2_HT_DAMAGE_SCRIPT = "";
