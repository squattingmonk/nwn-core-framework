// -----------------------------------------------------------------------------
//    File: hook_placeable01.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Placeable OnClick event script. Place this script on the OnClick event under
// Placeable Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(PLACEABLE_EVENT_ON_CLICK, GetPlaceableLastClickedBy());
}
