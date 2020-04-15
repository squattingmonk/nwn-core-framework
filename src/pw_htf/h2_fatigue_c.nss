/*
Filename:           h2_fatigue_c
System:             fatigue
Author:             Edward Beck (0100010)
Date Created:       Sept. 11th, 2006
Summary:
HCR2 h2_hungerthrst_c script.
This is a configuration script for the hunger and thirst subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

//You may swap the below #include "h2_fatigue_t"  text directives for an equivalant language specific
//one. (All variable names must match however for it to compile properly.)
#include "h2_fatigue_t"

//The number of game hours a character can go without risk of
//enduring negative effects of not resting.
//After this time period elapses, fortidue checks of increasing difficulty are made.
//Failing this causes the character to become fatigued.
//10 hours after the below number of hours, the character is automatically fatigued
//and failing a fortitude check results in collapse.
const int H2_FATIGUE_HOURS_WITHOUT_REST = 24;

//Set to true to turn on the fatigue info bar which is displayed each game hour.
//Set to false to turn it off.
const int H2_FATIGUE_DISPLAY_INFO_BAR = TRUE;
