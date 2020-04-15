/*
Filename:           h2_torchlantrn_c
System:             torches and lanterns
Author:             Edward Beck (0100010)
Date Created:       Aug. 30, 2006
Summary:
HCR2 h2_torchlantrn_c script.
This is a configuration script for the torches and lanterns subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

//You may swap the below #include "h2_torchlantrn_t"  text directives for an equivalant language specific
//one. (All variable names must match however for it to compile properly.)
#include "h2_torchlantrn_t"

//Time in real-life seconds before a torch burns out.
//PHB rules is 1 hours of burn time.
//You could set this to Minutes per game hour * 60 to be purely by the PHB.
//That is rather short though if the default minutes per hour is 2.
//(which means a torch would burn out in 2 RL minutes)
//3600 = 1 RL hour.
const int H2_TORCH_BURN_COUNT = 3600;

//Time in real-life seconds before a lantern's oil runs out.
//21600 = 6 RL hours.
//You could set this to Minutes per game hour * 360to be purely by the PHB.
//That is rather short though if the default minutes per hour is 2.
//(which means a lantern would run out of oil in 12 RL minutes)
const int H2_LANTERN_BURN_COUNT = 21600;

//The tag of your lantern object
//If you change this be sure to save a new copy of h2_lantern
//as the new tag name to preserve functionality
const string H2_LANTERN = "h2_lantern";

//The tag of your oilflask object
//If you change this be sure to save a new copy of h2_oilflask
//as the new tag name to preserve functionality
const string H2_OILFLASK = "h2_oilflask";
