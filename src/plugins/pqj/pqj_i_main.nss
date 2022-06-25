// -----------------------------------------------------------------------------
//    File: pqj_i_main.nss
//  System: Persistent Quests and Journals (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This is the main include file for the Persistent Quests and Journals plugin.
// -----------------------------------------------------------------------------

#include "util_i_debug"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< pqj_CreateTable >---
// ---< pqj_i_main >---
// Creates a table for PQJ quest data in oPC's persistent SQLite database. If
// bForce is true, will drop any existing table before creating a new one.
void pqj_CreateTable(object oPC, int bForce = FALSE);

// ---< pqj_RestoreJournalEntries >---
// ---< pqj_i_main >---
// Restores all journal entries from oPC's persistent SQLite database. This
// should be called once OnClientEnter. Ensure the table has been created using
// pqj_CreateTable() before calling this.
void pqj_RestoreJournalEntries(object oPC);

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

void pqj_CreateTable(object oPC, int bForce = FALSE)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return;

    if (bForce)
        SqlStep(SqlPrepareQueryObject(oPC, "DROP TABLE IF NOT EXISTS pqjdata;"));

    string sMessage = "creating table pqjdata on " + GetName(oPC);
    string sQuery = "CREATE TABLE IF NOT EXISTS pqjdata (" +
        "quest TEXT NOT NULL PRIMARY KEY, " +
        "state INTEGER NOT NULL DEFAULT 0);";
    sqlquery qQuery = SqlPrepareQueryObject(oPC, sQuery);
    SqlStep(qQuery);

    string sError = SqlGetError(qQuery);
    if (sError == "")
        Notice(HexColorString("[Success] ", COLOR_GREEN) + sMessage);
    else
        CriticalError(sMessage + ": " + sError);
}

void pqj_RestoreJournalEntries(object oPC)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return;

    int    nState;
    string sPlotID;
    string sName = GetName(oPC);
    string sQuery = "SELECT quest, state FROM pqjdata";
    sqlquery qQuery = SqlPrepareQueryObject(oPC, sQuery);
    while (SqlStep(qQuery))
    {
        sPlotID = SqlGetString(qQuery, 0);
        nState = SqlGetInt(qQuery, 1);
        Debug("Restoring journal entry; PC: " + sName + ", " +
              "PlotID: " + sPlotID + "; PlotState: " + IntToString(nState));
        AddJournalQuestEntry(sPlotID, nState, oPC, FALSE);
    }
}

int pqj_GetQuestState(string sPlotID, object oPC)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return 0;

    string sQuery = "SELECT state FROM pqjdata WHERE quest=@quest;";
    sqlquery qQuery = SqlPrepareQueryObject(oPC, sQuery);
    SqlBindString(qQuery, "@quest", sPlotID);
    SqlStep(qQuery);
    return SqlGetInt(qQuery, 0);
}

// Internal function for pqj_AddJournalQuestEntry().
void _StoreQuestEntry(string sPlotID, int nState, object oPC, int bAllowOverrideHigher = FALSE)
{
    string sMessage = "persistent journal entry for " + GetName(oPC) + "; " +
        "sPlotID: " + sPlotID + "; nState: " + IntToString(nState);
    string sQuery = "INSERT INTO pqjdata (quest, state) " +
        "VALUES (@quest, @state) ON CONFLICT (quest) DO UPDATE SET state = " +
        (bAllowOverrideHigher ? "@state" : "MAX(state, @state)") + ";";
    sqlquery qQuery = SqlPrepareQueryObject(oPC, sQuery);
    SqlBindString(qQuery, "@quest", sPlotID);
    SqlBindInt(qQuery, "@state", nState);
    SqlStep(qQuery);

    string sError = SqlGetError(qQuery);
    if (sError == "")
        Debug("Adding " + sMessage);
    else
        CriticalError("Could not add " + sMessage + ": " + sError);
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

    string sQuery = "DELETE FROM pqjdata WHERE quest=@quest;";
    sqlquery qQuery = SqlPrepareQueryObject(oPC, sQuery);
    SqlBindString(qQuery, "@quest", sPlotID);
    SqlStep(qQuery);

    string sError = SqlGetError(qQuery);
    if (sError == "")
        Debug("Removed " + sMessage);
    else
        CriticalError("Could not remove " + sMessage + ": " + sError);
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
