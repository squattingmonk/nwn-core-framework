/*
Filename:           h2_torch
System:             torches and lanterns
Author:             Edward Beck (0100010)
Date Created:       Aug. 30, 2006
Summary:
HCR2 h2_torch item script.
This script fires via tag based scripting for the OnEquip, OnUnEquip events for this item.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date:
Revision Author:
Revision Summary:

*/

#include "h2_torchlantrn_i"
#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();

    // * This code runs when the item is equipped
    // * Note that this event fires PCs only
    if (nEvent ==  X2_ITEM_EVENT_EQUIP)
    {
        h2_EquippedLightSource(FALSE);
    }
    // * This code runs when the item is unequipped
    // * Note that this event fires for PCs only
    else if (nEvent == X2_ITEM_EVENT_UNEQUIP)
    {
        h2_UnEquipLightSource(FALSE);
    }
}
