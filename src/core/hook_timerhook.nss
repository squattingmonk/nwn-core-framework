/// ----------------------------------------------------------------------------
/// @file   hook_timerhook.nss
/// @author Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
/// @brief  Hook script that handles timers as Core Framework events.
/// ----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    string sEvent  = GetScriptParam(TIMER_ACTION);
    string sSource = GetScriptParam(TIMER_SOURCE);
    object oSource = StringToObject(sSource);
    RunEvent(sEvent, oSource);
}
