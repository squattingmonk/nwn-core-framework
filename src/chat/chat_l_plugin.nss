// -----------------------------------------------------------------------------
//    File: chat_l_plugin.nss
//  System: Chat Command System (library script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Edward A. Burke (tinygiant) <af.hog.pilot@gmail.com>
// -----------------------------------------------------------------------------

#include "util_i_library"
#include "chat_i_main"
#include "core_i_framework"

// -----------------------------------------------------------------------------
//                                 OnPlayerChat
// -----------------------------------------------------------------------------

void chat_OnPlayerChat()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetPCChatMessage();

    if (ParseCommandLine(oPC, sMessage))
    {
        SetPCChatMessage();
        string sDesignator = GetChatDesignator(oPC);
        string sCommand = GetChatCommand(oPC);

        int nState = RunEvent(CHAT_PREFIX + sDesignator, oPC);
        if (!(nState & EVENT_STATE_DENIED))
            RunEvent(CHAT_PREFIX + sDesignator + sCommand, oPC);
    }
}

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!GetIfPluginExists("chat"))
    {
        object oPlugin = GetPlugin("chat", TRUE);
        SetName(oPlugin, "[Plugin] Chat Command System");
        SetDescription(oPlugin,
            "Allows players and DMs to run commands via the chat bar");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_PLAYER_CHAT,
            "chat_OnPlayerChat", EVENT_PRIORITY_FIRST);
    }

    RegisterLibraryScript("chat_OnPlayerChat", 1);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1: chat_OnPlayerChat(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
