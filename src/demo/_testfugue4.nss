

void main()
{
    object oPC = GetEnteringObject();
    SendMessageToPC(oPC, "Welcome, from the fugue waypoint.");

object oSelf = OBJECT_SELF;
string sTag = GetTag(oSelf);

if(sTag=="FloorLever1")
    {SendMessageToPC(GetLastUsedBy(), "Bye! From the lever."); return;}
if(sTag=="h2_fugueplane")
    {SendMessageToPC(GetEnteringObject(), "Hello, From the area."); return;}
SendMessageToPC(GetEnteringObject(), "Hello, from the waypoint.");
}
