/*
Filename:           h2_fugueexit_e
System:             FuguePlayerDeath (area exit event for the FuguePlane)
Author:             Edward Beck (0100010)
Date Created:       Mar. 12, 2006
Summary:
HCR2 event script.
This script should be attachted to the area exit event for the fugue plane on its respective scripts tab.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/
#include "h2_fuguedeath_i"

void main()
{
    object oPC = GetExitingObject();
    DeleteLocalInt(oPC, H2_LOGIN_DEATH);
    h2_SetPlayerPersistentInt(oPC, H2_PLAYER_STATE, H2_PLAYER_STATE_ALIVE);
}
