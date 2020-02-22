// -----------------------------------------------------------------------------
//    File: pqj_i_main.nss
//  System: Persistent Quests and Journals (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This is the main include file for the Persistent Quests and Journals plugin.
// -----------------------------------------------------------------------------

#include "core_i_database"
#include "util_i_csvlists"

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

const string PQJ_TABLE_SQLITE = "pqjdata (pc_id INTEGER, plot_id VARCHAR(32) NOT NULL DEFAULT '', state INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (pc_id, plot_id), FOREIGN KEY (pc_id) REFERENCES pc (id) ON DELETE CASCADE ON UPDATE CASCADE)";
const string PQJ_TABLE_MYSQL  = "pqjdata (pc_id INT UNSIGNED NOT NULL DEFAULT 0, plot_id VARCHAR(32) NOT NULL DEFAULT '', state INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (pc_id, plot_id), FOREIGN KEY (pc_id) REFERENCES pc (id) ON DELETE CASCADE ON UPDATE CASCADE)";

const string PQJ_PREFIX  = "PQJ PlotID: ";
const string PQJ_ENTRIES = "PQJ Entries";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< pqj_GetQuestState >---
// ---< pqj_i_main >---
// Returns the state of a quest for the PC. This matches a plot ID and number
// from the journal.
int pqj_GetQuestState(string sPlotID, object oPC);

// ---< pqj_AddJournalQuestEntry >---
// ---< pqj_i_main >---
// As AddJournalQuestEntry(), but stores the quest state in the database so it
// can be restored after a server reset.
void pqj_AddJournalQuestEntry(string sPlotID, int nState, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE, int bAllowOverrideHigher = FALSE);

// ---< pqj_RemoveJournalQuestEntry >---
// ---< pqj_i_main >---
// As RemoveJournalQuestEntry(), but removes the quest from the database so it
// will not be restored after a server reset.
void pqj_RemoveJournalQuestEntry(string sPlotID, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE);

// -----------------------------------------------------------------------------
//                              Funcion Definitions
// -----------------------------------------------------------------------------

int pqj_GetQuestState(string sPlotID, object oPC)
{
    if (!GetIsPC(oPC))
        return 0;

    int nDatabase = GetDatabaseType();
    if (nDatabase)
    {
        string sPCID = GetPCID(oPC);
        string sQuery = "SELECT state FROM pqjdata WHERE pc_id=? AND plot_id=?";

        if (NWNX_SQL_PrepareAndExecuteQuery(sQuery, sPCID, sPlotID) &&
            NWNX_SQL_ReadyToReadNextRow())
        {
            NWNX_SQL_ReadNextRow();
            return StringToInt(NWNX_SQL_ReadDataInActiveRow());
        }

        return 0;
    }

    return GetCampaignInt(FALLBACK_DATABASE, PQJ_PREFIX + sPlotID, oPC);
}

// Internal function for pqj_AddJournalQuestEntry().
void _StoreQuestEntry(string sPlotID, int nState, object oPC, int bAllowOverrideHigher = FALSE)
{
    string sName    = GetName(oPC);
    string sState   = IntToString(nState);
    string sMessage = "persistent journal entry for " + sName + "; " +
                      "PlotID: " + sPlotID + "; PlotState: " + sState;

    int nDatabase = GetDatabaseType();
    if (nDatabase)
    {
        string sQuery;
        string sPCID = GetPCID(oPC);

        switch (nDatabase)
        {
            case DATABASE_TYPE_SQLITE:
            {
                sQuery = "INSERT INTO pqjdata (pc_id, plot_id, state) " +
                         "VALUES (?, ?, ?) ON CONFLICT (pc_id, plot_id) " +
                         "DO UPDATE SET state = ";
                sQuery += bAllowOverrideHigher ? "?" : "MAX(state, ?)";
            } break;

            case DATABASE_TYPE_MYSQL:
            {
                sQuery = "INSERT INTO pqjdata (pc_id, plot_id, state) " +
                         "VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE state = ";
                sQuery += bAllowOverrideHigher ? "?" : "GREATEST(state, ?)";
            } break;
        }

        if (NWNX_SQL_PrepareAndExecuteQuery(sQuery, sPCID, sPlotID, sState, sState))
            Debug("Adding " + sMessage);
        else
        {
            string sError = NWNX_SQL_GetLastError();
            Debug("Could not add " + sMessage + ": " + sError, DEBUG_LEVEL_CRITICAL);
        }
    }
    else
    {
        int bStore = TRUE;
        int nStored = GetCampaignInt(FALLBACK_DATABASE, PQJ_PREFIX + sPlotID, oPC);

        if (nStored)
            bStore = (nState > nStored || bAllowOverrideHigher);
        else
        {
            string sPlotIDs = GetCampaignString(FALLBACK_DATABASE, PQJ_ENTRIES, oPC);
            sPlotIDs = AddListItem(sPlotIDs, sPlotID, TRUE);
            SetCampaignString(FALLBACK_DATABASE, PQJ_ENTRIES, sPlotIDs, oPC);
        }

        if (bStore)
        {
            if (nStored)
                Debug("Updating " + sMessage + " from state " + IntToString(nStored));
            else
                Debug("Adding " + sMessage);

            SetCampaignInt(FALLBACK_DATABASE, PQJ_PREFIX + sPlotID, nState, oPC);
        }
        else
            Debug("Will not update " + sMessage + " because current state is " +
                  IntToString(nStored));
    }
}

void pqj_AddJournalQuestEntry(string sPlotID, int nState, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE, int bAllowOverrideHigher = FALSE)
{
    if (!GetIsPC(oPC))
        return;

    AddJournalQuestEntry(sPlotID, nState, oPC, bAllPartyMembers, bAllPlayers, bAllowOverrideHigher);

    if (bAllPlayers)
    {
        Debug("Adding journal entry " + sPlotID + " for all players");
        oPC = GetFirstPC();
        while (GetIsObjectValid(oPC))
        {
            _StoreQuestEntry(sPlotID, nState, oPC, bAllowOverrideHigher);
            oPC = GetNextPC();
        }
    }
    else if (bAllPartyMembers)
    {
        Debug("Adding journal entry " + sPlotID + " for " + GetName(oPC) +
              "'s party members");
        object oPartyMember = GetFirstFactionMember(oPC, TRUE);
        while (GetIsObjectValid(oPartyMember))
        {
            _StoreQuestEntry(sPlotID, nState, oPartyMember, bAllowOverrideHigher);
            oPartyMember = GetNextFactionMember(oPC, TRUE);
        }
    }
    else
        _StoreQuestEntry(sPlotID, nState, oPC, bAllowOverrideHigher);
}

// Internal function for pqj_RemoveJournalQuestEntry()
void _DeleteQuestEntry(string sPlotID, object oPC)
{
    string sName    = GetName(oPC);
    string sMessage = "persistent journal entry for " + sName + "; " +
                      "PlotID: " + sPlotID;

    int nDatabase = GetDatabaseType();

    if (nDatabase)
    {
        string sPCID  = GetPCID(oPC);
        string sQuery = "DELETE FROM pqjdata WHERE pc_id=? AND plot_id=?";

        if (NWNX_SQL_PrepareAndExecuteQuery(sQuery, sPCID, sPlotID))
        {
            if (NWNX_SQL_GetAffectedRows())
                Debug("Removed " + sMessage);
            else
                Debug("No " + sMessage);
        }
        else
        {
            string sError = NWNX_SQL_GetLastError();
            Debug("Could not remove " + sMessage + ": " + sError,
                  DEBUG_LEVEL_CRITICAL);
        }
    }
    else
    {
        string sPlotIDs = GetCampaignString(FALLBACK_DATABASE, PQJ_ENTRIES, oPC);
        string sUpdated = RemoveListItem(sPlotIDs, sPlotID);

        if (sPlotIDs == sUpdated)
            Debug("No " + sMessage);
        else
        {
            Debug("Removing " + sMessage);
            SetCampaignString(FALLBACK_DATABASE, PQJ_ENTRIES, sUpdated, oPC);
            DeleteCampaignVariable(FALLBACK_DATABASE, PQJ_PREFIX + sPlotID, oPC);
        }
    }
}

void pqj_RemoveJournalQuestEntry(string sPlotID, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE)
{
    RemoveJournalQuestEntry(sPlotID, oPC, bAllPartyMembers, bAllPlayers);

    if (bAllPlayers)
    {
        Debug("Removing journal entry " + sPlotID + " for all players");
        oPC = GetFirstPC();
        while (GetIsObjectValid(oPC))
        {
            _DeleteQuestEntry(sPlotID, oPC);
            oPC = GetNextPC();
        }
    }
    else if (bAllPartyMembers)
    {
        Debug("Removing journal entry " + sPlotID + " for " + GetName(oPC) +
              "'s party members");
        object oPartyMember = GetFirstFactionMember(oPC, TRUE);
        while (GetIsObjectValid(oPartyMember))
        {
            _DeleteQuestEntry(sPlotID, oPartyMember);
            oPartyMember = GetNextFactionMember(oPC, TRUE);
        }
    }
    else
        _DeleteQuestEntry(sPlotID, oPC);
}
