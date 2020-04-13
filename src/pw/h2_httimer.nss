/*
Filename:           h2_httimer
System:             hunger and thirst
Author:             Edward Beck (0100010)
Date Created:       Sept. 9, 2006
Summary:
HCR2 h2_httimer script.
This is a timer script that is run by the hunger and thirst subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_hungerthrst_i"

void main()
{
    h2_PerformHungerThirstCheck(OBJECT_SELF);
}
