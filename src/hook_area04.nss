// -----------------------------------------------------------------------------
//    File: hook_area04.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Area OnUserDefined event script. Place this script on the OnUserDefined event
// under Area Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(AREA_EVENT_ON_USER_DEFINED);
}
