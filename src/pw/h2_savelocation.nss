/*
Filename:           h2_savelocation
System:             core (timer script to save location)
Author:             Edward Beck (0100010)
Date Created:       Oct. 1, 2005
Summary:
An example for an executed Timer event
which saves the PC's location each time the script is fired from the elapsed timer.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_core_i"

void main()
{
    if (GetIsObjectValid(OBJECT_SELF) && GetIsPC(OBJECT_SELF))
    {
        location loc = GetLocation(OBJECT_SELF);
        h2_SavePCLocation(OBJECT_SELF);
    }
}
