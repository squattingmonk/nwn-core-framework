// -----------------------------------------------------------------------------
//    File: hook_module14.nss
//  System: Core Framework (event hook-in script
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// OnPlerRest event hook-in script. Place this script on the OnPlayerRest event
// under Module Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    object oPC = GetLastPCRested();
    int nState = RunEvent(MODULE_EVENT_ON_PLAYER_REST, oPC);

    // Aborting from the base rest event will abort the other rest events. This
    // allows an OnPlayerRest script to decide if sub-events can fire at all.
    if (nState == EVENT_STATE_OK)
    {
        string sEvent;

        // Process the rest sub-events
        switch (GetLastRestEventType())
        {
            case REST_EVENTTYPE_REST_STARTED:
                sEvent = MODULE_EVENT_ON_PLAYER_REST_STARTED;
                break;

            case REST_EVENTTYPE_REST_CANCELLED:
                sEvent = MODULE_EVENT_ON_PLAYER_REST_CANCELLED;
                break;

            case REST_EVENTTYPE_REST_FINISHED:
                sEvent = MODULE_EVENT_ON_PLAYER_REST_FINISHED;
                break;
        }

        RunEvent(sEvent, oPC);
    }
}
