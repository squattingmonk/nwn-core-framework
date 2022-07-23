#include "pqj_i_main"

void main()
{
    object oPC = GetLastUsedBy();
    int nState = pqj_GetQuestState("test", oPC);
    if (nState > 1)
        pqj_RemoveJournalQuestEntry("test", oPC);
    else
        pqj_AddJournalQuestEntry("test", nState + 1, oPC);
}
