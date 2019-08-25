# Core Utilities: Lists

Two types of lists are available. Conversions between the two list types can be
done using the functions in `util_i_lists.nss`.

## CSV Lists
`util_i_csvlists.nss` holds functions for CSV lists. These are comma-separated
string lists that are altered in place. They are zero-indexed.

``` c
// Create a list of knights, then count and loop through the list
string sKnight, sKnights = "Lancelot, Galahad, Robin";
int i, nCount = CountList(sKnights);
for (i = 0; i < nCount; i++)
{
    sKnight = GetListItem(sKnights, i);
    SpeakString("Sir " + sKnight);
}

// Check if Bedivere is in the party
int bBedivere = HasListItem(sKnights, "Bedivere");
SpeakString("Bedivere " + (bBedivere ? "is" : "is not") + " in the party.");

// Add Bedivere to the party
sKnights = AddListItem(sKnights, "Bedivere");
bBedivere = HasListItem(sKnights, "Bedivere");
SpeakString("Bedivere " + (bBedivere ? "is" : "is not") + " in the party.");

// Find the index of a knight in the party
int nRobin = FindListItem(sKnights, "Robin");
SpeakString("Robin is knight " + IntToString(nRobin) + " in the party.");
```

## Var Lists
`util_i_varlists.nss` contains functions for handling var lists. Var lists are
saved to objects as local variables. They support float, int, location, object,
and string datatypes. Each variable type is maintained in a separate list to
avoid collision.

``` c
// Create a list of menu items on the module
object oModule = GetModule();
AddListString(oModule, "Spam", "Menu");
AddListString(oModule, "Eggs", "Menu");
AddListString(oModule, "Spam and Eggs", "Menu");

// Add the prices
AddListInt(oModule, 10, "Menu");
AddListInt(oModule, 5,  "Menu");
AddListInt(oModule, 15, "Menu");

// Count the list of menu items and loop through it
int i, nCount = CountStringList(oModule, "Menu");
string sItem;
int nItem;

for (i = 0; i < nCount; i++)
{
    sItem = GetListString(oModule, i, "Menu");
    nItem = GetListInt   (oModule, i, "Menu");
    SpeakString(sItem + " costs " + IntToString(nItem) + " GP");
}

// Check to see if Eggs are on the menu
int bEggs = HasListString(oModule, "Eggs", "Menu");
SpeakString("Eggs " (bEggs ? "are" : "are not") + " on the menu.");

// Find an item that costs 15 GP from the menu
nItem = FindListInt(oModule, 15, "Menu");
sItem = GetListItem(oModule, nItem, "Menu");

// Delete the item and its price from the menu
DeleteListString(oModule, nItem, "Menu");
DeleteListInt   (oModule, nItem, "Menu");

// Copy the menu to OBJECT_SELF's list "Eats"
CopyStringList(oModule, OBJECT_SELF, "Menu", "Eats");
```
