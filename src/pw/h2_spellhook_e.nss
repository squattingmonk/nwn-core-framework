/*
Filename:           h2_spellhook_e
System:             core (spellhook event script)
Author:             Karl Nickels (Syrus Greycloak)
Date Created:       Jun 27, 2006
Summary:
HCR2 OnSpellhook Event.
This script should be set as the spellhook script in the
OnModuleLoad event script for the module.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_core_i"

void main()
{
    h2_RunModuleEventScripts(H2_EVENT_ON_SPELLHOOK);
}
