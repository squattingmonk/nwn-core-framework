#include "pqj_i_main"
#include "core_i_framework"

void main()
{
    object oPC = GetLastUsedBy();
    int nState = pqj_GetQuestState("test", oPC);
    if (nState > 1)
        pqj_RemoveJournalQuestEntry("test", oPC);
    else
        pqj_AddJournalQuestEntry("test", nState + 1, oPC);

    int nTimer = CreateTimer(oPC, "TestTimer", 6.0f, 4);
    StartTimer(nTimer);
    DelayCommand(12.0, StopTimer(nTimer));
    DelayCommand(24.0, KillTimer(nTimer));
}
