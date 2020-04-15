/*
Filename:           h2_pdataretire_a
System:             core (h2_playerdataconv menu node action script)
Author:             Edward Beck (0100010)
Date Created:       Apr. 1, 2006
Summary:

Action script that is fired when the retire pc menu item in the player info and action item conversation
is selected.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/


#include "h2_core_i"

void main()
{
    AssignCommand(OBJECT_SELF, ActionStartConversation(OBJECT_SELF, H2_RETIRE_PC_MENU_CONV, TRUE, FALSE));
}
