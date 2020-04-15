/*
Filename:           h2_htplconused_e
System:             hunger and thirst (placeable onused event script)
Author:             Edward Beck (0100010)
Date Created:       Sept. 10th, 2006
Summary:

h2_htplconused_e script. This script should be placed in the on used event
of a placeable that acts as a source of food or drink.

Make this placeable a useable, non-container and assign variables to it
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
    object oPC = GetLastUsedBy();
    SendMessageToPC(oPC, H2_TEXT_TAKE_A_DRINK);
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
    h2_ConsumeFoodItem(oPC, OBJECT_SELF);
}
