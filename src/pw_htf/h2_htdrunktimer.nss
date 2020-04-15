/*
Filename:           h2_htdrunktimer
System:             hunger and thirst
Author:             Edward Beck (0100010)
Date Created:       Sept. 10th, 2006
Summary:
HCR2 h2_htseunktimer script.
This is a timer script that is run by the hunger and thirst subsystem.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_hungerthrst_i"

void main()
{
    h2_DoDrunkenAntics(OBJECT_SELF);
}
