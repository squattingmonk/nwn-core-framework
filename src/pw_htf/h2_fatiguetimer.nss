/*
Filename:           h2_fatiguetimer
System:             fatigue
Author:             Edward Beck (0100010)
Date Created:       Sept. 11th, 2006
Summary:
HCR2 h2_fatiguetimer script.
This is a timer script that is run by the fatigue subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_fatigue_i"

void main()
{
    h2_PerformFatigueCheck(OBJECT_SELF);
}
