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
    int nDB = GetDatabaseType();
    if (nDB)
    {
        string sTable = (nDB == DATABASE_TYPE_SQLITE ? PQJ_TABLE_SQLITE :
                        (nDB == DATABASE_TYPE_MYSQL  ? PQJ_TABLE_MYSQL  : ""));

        if (CreateTable(sTable))
            Debug("Initialized PQJ database");
        else
        {
            string sError = NWNX_SQL_GetLastError();
            CriticalError("Could not initialize PQJ database: " + sError);
            SetEventState(EVENT_STATE_ABORT | EVENT_STATE_DENIED);
        }
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

    string sName = GetName(oPC);
    int nDatabase = GetDatabaseType();

    if (nDatabase)
    {
        string sPCID = GetPCID(oPC);
        string sQuery = "SELECT plot_id, state FROM pqjdata WHERE pc_id=?";

        if (NWNX_SQL_PrepareAndExecuteQuery(sQuery, sPCID))
        {
            string sPlotID, sState;

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
    else
    {
        string sDB = FALLBACK_DATABASE;
        string sPlotID, sPlotIDs = GetCampaignString(sDB, PQJ_ENTRIES, oPC);
        int nState, i, nCount = CountList(sPlotIDs);

        Debug("Found journal entries: " + sPlotIDs);

        for (i; i < nCount; i++)
        {
            sPlotID = GetListItem(sPlotIDs, i);
            nState = GetCampaignInt(sDB, PQJ_PREFIX + sPlotID, oPC);
            Debug("Restoring journal entry; PC: " + sName + ", " +
                  "PlotID: " + sPlotID + "; PlotState: " + IntToString(nState));
            AddJournalQuestEntry(sPlotID, nState, oPC, FALSE);
        }
    }
}

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

        RegisterEventScripts(oPlugin, PLUGIN_EVENT_ON_ACTIVATE,     "pqj_InitializeDatabase");
        RegisterEventScripts(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER, "pqj_RestoreJournalEntries");
    }

    RegisterLibraryScript("pqj_InitializeDatabase",    1);
    RegisterLibraryScript("pqj_RestoreJournalEntries", 2);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1:  pqj_InitializeDatabase();    break;
        case 2:  pqj_RestoreJournalEntries(); break;
        default: CriticalError("Library function " + sScript + " not found");
    }
}
