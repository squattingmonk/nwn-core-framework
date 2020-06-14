// -----------------------------------------------------------------------------
//    File: hook_module03.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnClientEnter event hook-in script. Place this script on the OnClientEnter
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetEnteringObject();

    // Set this info since we can't get it OnClientLeave
    SetLocalString(oPC, PC_CD_KEY,      GetPCPublicCDKey(oPC));
    SetLocalString(oPC, PC_PLAYER_NAME, GetPCPlayerName (oPC));

    int nState = RunEvent(MODULE_EVENT_ON_CLIENT_ENTER, oPC);

    // The DENIED flag signals booting the player. This should be done by the
    // script setting the DENIED flag.
    if (nState & EVENT_STATE_DENIED)
    {
        // Set an int on the PC so we know we're booting him from the login
        // event. This will tell the OnClientLeave event hook not to execute.
        SetLocalInt(oPC, LOGIN_BOOT, TRUE);
    }
    else
    {
        // If the PC is logging back in after being booted but he passed all the
        // checks this time, clear the boot int so OnClientLeave scripts will
        // correctly execute for him.
        DeleteLocalInt(oPC, LOGIN_BOOT);

        // This is a running count of the number of players in the module.
        // It will count DMs separately. This is a handy utility for counting
        // online players.
        if (GetIsDM(oPC))
        {    
            AddListObject(OBJECT_SELF, oPC, DM_ROSTER, TRUE);
            SetLocalInt(oPC, IS_DM, TRUE);
        }
        else if (GetIsPC(oPC))
        {
            AddListObject(OBJECT_SELF, oPC, PLAYER_ROSTER, TRUE);
            SetLocalInt(oPC, IS_PC, TRUE);
        }

        // Send the player the welcome message.
        DelayCommand(1.0, SendMessageToPC(oPC, WELCOME_MESSAGE));
    }
}
