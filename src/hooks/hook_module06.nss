// -----------------------------------------------------------------------------
//    File: hook_module06.nss
//  System: Core Framework (event hook-in script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnHeartbeat event hook-in script. Place this script on the OnHeartbeat event
// under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(MODULE_EVENT_ON_HEARTBEAT);

    if (ENABLE_ON_HOUR_EVENT)
    {
        int nHour    = GetTimeHour();
        int nOldHour = GetLocalInt(OBJECT_SELF, CURRENT_HOUR);

        // If the hour has changed since the last heartbeat
        if (nHour != nOldHour)
        {
            SetLocalInt(OBJECT_SELF, CURRENT_HOUR, nHour);
            RunEvent(MODULE_EVENT_ON_HOUR);

            // TODO: add more time-of-day hooks
        }

    }
}
