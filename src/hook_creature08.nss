// -----------------------------------------------------------------------------
//    File: hook_creature08.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Creature OnPerception event script. Place this script on the OnPerception
// event under Creature Properties.
// -----------------------------------------------------------------------------

#include "core_i_events"

void main()
{
    RunEvent(CREATURE_EVENT_ON_PERCEPTION, GetLastPerceived());
}
