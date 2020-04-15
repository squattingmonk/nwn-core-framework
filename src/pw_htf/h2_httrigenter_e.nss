/*
Filename:           h2_httrigenter_e
System:             hunger and thirst (trigger on enter event script)
Author:             Edward Beck (0100010)
Date Created:       Sept. 10th, 2006
Summary:

h2_httrigenter_e script. This script should be placed in the on enter event
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
    object oPC = GetEnteringObject();
    SetLocalObject(oPC, H2_HT_TRIGGER, OBJECT_SELF);
}
