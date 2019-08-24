// -----------------------------------------------------------------------------
//    File: hook_placeable10.nss
//  System: Core Framework (event script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// Placeable OnSpellCastAt event script. Place this script on the OnSpellCastAt
// event under Placeable Properties.
// -----------------------------------------------------------------------------

#include "core_i_framework"

void main()
{
    RunEvent(PLACEABLE_EVENT_ON_SPELL_CAST_AT, GetLastSpellCaster());
}
