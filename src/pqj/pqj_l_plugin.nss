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
//                               OnPluginActivate
// -----------------------------------------------------------------------------
// Creates the database tables needed to manage persistent quests.
// -----------------------------------------------------------------------------

void pqj_InitializeDatabase()
{
    if (CreateTable(TABLE_PQJDATA))
        Debug("Initialized PQJ database");
    else
    {
        string sError = NWNX_SQL_GetLastError();
        Debug("Could not initialize PQJ database: " + sError,
              DEBUG_LEVEL_CRITICAL);
        DeactivatePlugin(GetCurrentPlugin());
    }
}

// -----------------------------------------------------------------------------
//                                 OnClientEnter
// -----------------------------------------------------------------------------
// Restores journal entries from the database for the PC. Called OnClientEnter.
// -----------------------------------------------------------------------------

void pqj_RestoreJournalEntries()
{
    object oPC = GetEventTriggeredBy();
    if (!GetIsPC(oPC))
        return;

    string sPCID  = GetPCID(oPC);
    string sQuery = "SELECT plot_id, state FROM pqjdata WHERE pc_id=?";
    if (NWNX_SQL_PrepareAndExecuteQuery(sQuery, sPCID))
    {
        string sPlotID, sState;
        string sName = GetName(oPC);

        while (NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            sPlotID = NWNX_SQL_ReadDataInActiveRow(0);
            sState  = NWNX_SQL_ReadDataInActiveRow(1);
            Debug("Restoring journal entry; PC: " + sName + ", " +
                  "PlotID: " + sPlotID + "; PlotState: " + sState);
            AddJournalQuestEntry(sPlotID, StringToInt(sState), oPC, FALSE);
        }
    }
}

// -----------------------------------------------------------------------------
//                               Library Dispatch
// -----------------------------------------------------------------------------

void OnLibraryLoad()
{
    object oPlugin = GetCurrentPlugin();
    SetLocalString(oPlugin, CORE_EVENT_ON_PLUGIN_ACTIVATE, "pqj_InitializeDatabase");
    SetLocalString(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER,  "pqj_RestoreJournalEntries");

    RegisterLibraryScript("pqj_InitializeDatabase",    1);
    RegisterLibraryScript("pqj_RestoreJournalEntries", 2);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  pqj_InitializeDatabase();    break;
        case 2:  pqj_RestoreJournalEntries(); break;
        default: Debug("Library function " + sScript + " not found",
                       DEBUG_LEVEL_CRITICAL);
    }
}
