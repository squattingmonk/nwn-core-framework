#include "util_i_color"

object oPC = GetLastUsedBy();
string sText = "The quick brown fox jumps over the lazy dog";

void PrintColor(string sColor, int nColor)
{
    SendMessageToPC(oPC, HexColorString(sColor + ": " + IntToHexString(nColor), nColor));
}

void PrintHexColor(int nColor)
{
    string sMessage = IntToHexString(nColor) + ": " + sText;
    SendMessageToPC(oPC, HexColorString(sMessage, nColor));
}

void main()
{
    PrintColor("Black", COLOR_BLACK);
    PrintColor("Blue", COLOR_BLUE);
    PrintColor("Dark Blue", COLOR_BLUE_DARK);
    PrintColor("Light Blue", COLOR_BLUE_LIGHT);
    PrintColor("Brown", COLOR_BROWN);
    PrintColor("Light Brown", COLOR_BROWN_LIGHT);
    PrintColor("Divine", COLOR_DIVINE);
    PrintColor("Gold", COLOR_GOLD);
    PrintColor("Gray", COLOR_GRAY);
    PrintColor("Dark Gray", COLOR_GRAY_DARK);
    PrintColor("Light Gray", COLOR_GRAY_LIGHT);
    PrintColor("Green", COLOR_GREEN);
    PrintColor("Dark Green", COLOR_GREEN_DARK);
    PrintColor("Light Green", COLOR_GREEN_LIGHT);
    PrintColor("Orange", COLOR_ORANGE);
    PrintColor("Dark Orange", COLOR_ORANGE_DARK);
    PrintColor("Light Orange", COLOR_ORANGE_LIGHT);
    PrintColor("Red", COLOR_RED);
    PrintColor("Dark Red", COLOR_RED_DARK);
    PrintColor("Light Red", COLOR_RED_LIGHT);
    PrintColor("Pink", COLOR_PINK);
    PrintColor("Purple", COLOR_PURPLE);
    PrintColor("Turquoise", COLOR_TURQUOISE);
    PrintColor("Violet", COLOR_VIOLET);
    PrintColor("Light Violet", COLOR_VIOLET_LIGHT);
    PrintColor("Dark Violet", COLOR_VIOLET_DARK);
    PrintColor("White", COLOR_WHITE);
    PrintColor("Yellow", COLOR_YELLOW);
    PrintColor("Dark Yellow", COLOR_YELLOW_DARK);
    PrintColor("Light Yellow", COLOR_YELLOW_LIGHT);

    PrintHexColor(0x0099fe);
    PrintHexColor(0x3dc93d);

    struct HSV hsv = HexToHSV(0xff0000);
    PrintHexColor(HSVToHex(hsv));
    SpeakString("H: " + FloatToString(hsv.h) +
               " S: " + FloatToString(hsv.s) +
               " V: " + FloatToString(hsv.v));
    hsv.v /= 2.0;
    hsv.s = 0.0;
    PrintHexColor(HSVToHex(hsv));


}
