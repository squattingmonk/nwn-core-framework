/*
Filename:           h2_httrigexit_e
System:             hunger and thirst (trigger on exit event script)
Author:             Edward Beck (0100010)
Date Created:       Sept. 10th, 2006
Summary:

h2_httrigexit_e script. This script should be placed in the on exit event
of a trigger that acts as a canteen source of food or drink.

Paint the trigger on the ground and assign variables to it
in the same way that you would assign variables to an h2_fooditem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "h2_hungerthrst_i"

void main()
{
    object oPC = GetExitingObject();
    DeleteLocalObject(oPC, H2_HT_TRIGGER);
}
