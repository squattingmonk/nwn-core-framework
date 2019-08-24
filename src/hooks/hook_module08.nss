// -----------------------------------------------------------------------------
//    File: hook_module08.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnPlayerChat event hook-in script. Place this script on the OnPlayerChat
// event under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetPCChatSpeaker();

    // Suppress the chat message if the player is being booted. This will stop
    // players from executing chat commands or spamming the server when banned.
    if (GetLocalInt(oPC, LOGIN_BOOT))
        SetPCChatMessage();
    else
    {
        int nState = RunEvent(MODULE_EVENT_ON_PLAYER_CHAT);
        if (nState & EVENT_STATE_DENIED)
            SetPCChatMessage();
    }
}
