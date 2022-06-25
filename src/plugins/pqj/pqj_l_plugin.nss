// -----------------------------------------------------------------------------
//    File: pqj_l_plugin.nss
//  System: Persistent Quests and Journals (library script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This library script contains scripts to hook in to Core Framework events.
// -----------------------------------------------------------------------------

#include "util_i_library"
#include "core_i_framework"
#include "pqj_i_main"

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    if (!GetIfPluginExists("pqj"))
    {
        object oPlugin = GetPlugin("pqj", TRUE);
        SetName(oPlugin, "[Plugin] Persistent Quests and Journals");
        SetDescription(oPlugin,
            "This plugin allows database-driven persistent journal entries.");

        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER, "pqj_RestoreJournalEntries");
    }

    RegisterLibraryScript("pqj_RestoreJournalEntries", 1);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:
        {
            object oPC = GetEventTriggeredBy();
            pqj_CreateTable(oPC);
            pqj_RestoreJournalEntries(oPC);
        } break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
