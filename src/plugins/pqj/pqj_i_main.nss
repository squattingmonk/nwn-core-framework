// -----------------------------------------------------------------------------
//    File: pqj_i_main.nss
//  System: Persistent Quests and Journals (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This is the main include file for the Persistent Quests and Journals plugin.
// -----------------------------------------------------------------------------

#include "util_i_debug"
#include "util_i_sqlite"

// -----------------------------------------------------------------------------
//                              Constants
// -----------------------------------------------------------------------------

const int QUEST_NOT_TAKEN_INT = 0;
const int QUEST_IN_PROGRESS_INT = 1;
const int QUEST_COMPLETE_INT = 2;
const int QUEST_COMPLETE_OTHER_INT = 3;

const string QUEST_NOT_TAKEN_STRING = "Quest not taken";
const string QUEST_IN_PROGRESS_STRING = "Quest in progress";
const string QUEST_COMPLETE_STRING = "Quest complete";
const string QUEST_COMPLETE_OTHER_STRING = "Quest completed by someone else";

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
// from the journal. Returns 0 if the quest has not been started.
int pqj_GetQuestState(string sPlotID, object oPC);

// ---< pqj_GetQuestStatus >---
// ---< pqj_i_main >---
// Returns the status of a quest for the PC. This matches a plot ID and number
// from the journal. Returns 0 if the quest has not been started.
int pqj_GetQuestStatus(string sPlotID, object oPC);

// ---< pqj_AddJournalQuestEntry >---
// ---< pqj_i_main >---
// As AddJournalQuestEntry(), but stores the quest state and status in the database so it
// can be restored after a server reset.
void pqj_AddJournalQuestEntry(string sPlotID, int nState, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE, int bAllowOverrideHigher = FALSE, int nStatus = QUEST_NOT_TAKEN_INT);

// ---< pqj_UpdateQuest >---
// ---< pqj_i_main >---
// As pqj_AddJournalQuestEntry(), but automatically set status to 1 (In Progress).
void pqj_UpdateQuest(string sPlotID, int nState, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE, int bAllowOverrideHigher = FALSE);

// ---< pqj_FinishQuest >---
// ---< pqj_i_main >---
// As pqj_AddJournalQuestEntry(), but automatically set status to 1 (Complete).
void pqj_FinishQuest(string sPlotID, int nState, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE, int bAllowOverrideHigher = FALSE);

// ---< pqj_RemoveJournalQuestEntry >---
// ---< pqj_i_main >---
// As RemoveJournalQuestEntry(), but removes the quest from the database so it
// will not be restored after a server reset.
void pqj_RemoveJournalQuestEntry(string sPlotID, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE);

// ---< pqj_QuestStatusToString >---
// ---< pqj_i_main >---
// Gets nStatus and returns a string respective to it.
string pqj_QuestStatusToString(int nStatus);

// -----------------------------------------------------------------------------
//                              Funcion Definitions
// -----------------------------------------------------------------------------

void pqj_CreateTable(object oPC, int bForce = FALSE)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return;

    Debug("Creating table pqjdata on " + GetName(oPC));
    SqlCreateTablePC(oPC, "pqjdata",
        "quest TEXT NOT NULL PRIMARY KEY, " +
        "state INTEGER NOT NULL DEFAULT 0, " +
        "status INTEGER NOT NULL DEFAULT 0", bForce);
}

void pqj_RestoreJournalEntries(object oPC)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return;

    int    nState;
    int    nStatus;
    string sPlotID;
    string sName = GetName(oPC);
    string sQuery = "SELECT quest, state, status FROM pqjdata";
    sqlquery qQuery = SqlPrepareQueryObject(oPC, sQuery);
    while (SqlStep(qQuery))
    {
        sPlotID = SqlGetString(qQuery, 0);
        nState = SqlGetInt(qQuery, 1);
        nStatus = SqlGetInt(qQuery, 2);
        Debug("Restoring journal entry; PC: " + sName + ", " +
              "PlotID: " + sPlotID + "; PlotState: " + IntToString(nState) +
              "; PlotStatus: " + IntToString(nStatus) + " (" + pqj_QuestStatusToString(nStatus) + ")");
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
    if (SqlStep(qQuery))
        return SqlGetInt(qQuery, 0);

    return 0;
}

int pqj_GetQuestStatus(string sPlotID, object oPC)
{
    if (!GetIsPC(oPC) || GetIsDM(oPC))
        return 0;

    string sQuery = "SELECT status FROM pqjdata WHERE quest=@quest;";
    sqlquery qQuery = SqlPrepareQueryObject(oPC, sQuery);
    SqlBindString(qQuery, "@quest", sPlotID);
    if (SqlStep(qQuery))
        return SqlGetInt(qQuery, 0);

    return 0;
}

// Internal function for pqj_AddJournalQuestEntry().
// void _StoreQuestEntry(string sPlotID, int nState, object oPC, int bAllowOverrideHigher = FALSE)
void _StoreQuestEntry(string sPlotID, int nState, object oPC, int bAllowOverrideHigher = FALSE, int nStatus = QUEST_NOT_TAKEN_INT)
{
    string sMessage = "persistent journal entry for " + GetName(oPC) + "; " +
        "sPlotID: " + sPlotID + "; nState: " + IntToString(nState) + "; nStatus: " +
        IntToString(nStatus) + " (" + pqj_QuestStatusToString(nStatus) + ")";
    string sQuery = "INSERT INTO pqjdata (quest, state, status) " +
        "VALUES (@quest, @state, @status) ON CONFLICT (quest) DO UPDATE SET state = " +
        (bAllowOverrideHigher ? "@state" : "MAX(state, @state)") +
        ", status = " + (bAllowOverrideHigher ? "@status" : "MAX(status, @status)") + ";";
    sqlquery qQuery = SqlPrepareQueryObject(oPC, sQuery);
    SqlBindString(qQuery, "@quest", sPlotID);
    SqlBindInt(qQuery, "@state", nState);
    SqlBindInt(qQuery, "@status", nStatus);
    SqlStep(qQuery);

    string sError = SqlGetError(qQuery);
    if (sError == "")
        Debug("Adding " + sMessage);
    else
        CriticalError("Could not add " + sMessage + ": " + sError);
}

void pqj_AddJournalQuestEntry(string sPlotID, int nState, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE, int bAllowOverrideHigher = FALSE, int nStatus = QUEST_NOT_TAKEN_INT)
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
            _StoreQuestEntry(sPlotID, nState, oPC, bAllowOverrideHigher, nStatus);
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
            if(nStatus == QUEST_COMPLETE_INT)
            {
                _StoreQuestEntry(sPlotID, nState, oPartyMember, bAllowOverrideHigher, QUEST_COMPLETE_OTHER_INT);
            }
            else
            {
                _StoreQuestEntry(sPlotID, nState, oPartyMember, bAllowOverrideHigher, nStatus);
            }
            oPartyMember = GetNextFactionMember(oPC, TRUE);
        }
    }
    else
        _StoreQuestEntry(sPlotID, nState, oPC, bAllowOverrideHigher, nStatus);
}

void pqj_UpdateQuest(string sPlotID, int nState, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE, int bAllowOverrideHigher = FALSE)
{
    pqj_AddJournalQuestEntry(sPlotID, nState, oPC, bAllPartyMembers, bAllPlayers, bAllowOverrideHigher, QUEST_IN_PROGRESS_INT);
}

void pqj_FinishQuest(string sPlotID, int nState, object oPC, int bAllPartyMembers = TRUE, int bAllPlayers = FALSE, int bAllowOverrideHigher = FALSE)
{
    pqj_AddJournalQuestEntry(sPlotID, nState, oPC, bAllPartyMembers, bAllPlayers, bAllowOverrideHigher, QUEST_COMPLETE_INT);
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

string pqj_QuestStatusToString(int nStatus)
{
    switch(nStatus)
    {
        default: case QUEST_NOT_TAKEN_INT:
            return QUEST_NOT_TAKEN_STRING;
        case QUEST_IN_PROGRESS_INT:
            return QUEST_IN_PROGRESS_STRING;
        case QUEST_COMPLETE_INT:
            return QUEST_COMPLETE_STRING;
        case QUEST_COMPLETE_OTHER_INT:
            return QUEST_COMPLETE_OTHER_STRING;
    }
    return QUEST_NOT_TAKEN_STRING;
}
