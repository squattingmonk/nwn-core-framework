// -----------------------------------------------------------------------------
//    File: hook_door01.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Door OnAreaTransitionClick event script. Place this script on the
// OnAreaTransitionClick event under Door Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(DOOR_EVENT_ON_AREA_TRANSITION_CLICK, GetEnteringObject());
}
