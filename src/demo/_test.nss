#include "pqj_i_main"

void main()
{
    object oPC = GetLastUsedBy();
    int nState = pqj_GetQuestState("test", oPC);
    pqj_AddJournalQuestEntry("test", nState + 1, oPC);
}
