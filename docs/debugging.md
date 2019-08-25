# Core Utilities: Debugging
`util_i_debug.nss` holds functions for generating debug messages. Use `Debug()`
to send a debug message. Debug messages have a level of importance associated
with them:
1. Critical errors are severe enough to stop the script from functioning
2. Errors indicate the script malfunctioned in some way
3. Warnings indicate that unexpected behavior may occur
4. Notices are general information used to track the flow of the script

The debug level can be set on individual objects or module-wide using
`SetDebugLevel()`. You can control how debug messages are displayed using
`SetDebugLogging()` and the colors of the messages using `SetDebugColor()`.
`IsDebugging()` can check to see if the object will show a debug message of the
given level; this is useful if you want to save cycles assembling a debug dump
that would not be shown.

``` c
// Set debug messages to be sent to the log and the first PC
SetDebugLogging(DEBUG_LOG_FILE | DEBUG_LOG_PC);

// Set the module to show debug messages of Error level or greater
SetDebugLevel(DEBUG_LEVEL_ERROR, GetModule());

// Generate some debug messages on OBJECT_SELF
Debug("My critical error", DEBUG_LEVEL_CRITICAL); // Displays
Debug("My error",          DEBUG_LEVEL_ERROR);    // Displays
Debug("My warning",        DEBUG_LEVEL_WARNING);  // Will not display
Debug("My notice",         DEBUG_LEVEL_NOTICE);   // Will not display

// Set OBJECT_SELF to show debug messages of Warning level or greater
SetDebugLevel(DEBUG_LEVEL_WARNING);

// Generate some debug messages on OBJECT_SELF
Debug("My critical error", DEBUG_LEVEL_CRITICAL); // Displays
Debug("My error",          DEBUG_LEVEL_ERROR);    // Displays
Debug("My warning",        DEBUG_LEVEL_WARNING);  // Displays
Debug("My notice",         DEBUG_LEVEL_NOTICE);   // Will not display

// Check if the message will be displayed before doing something intensive
if (IsDebugging(DEBUG_LEVEL_NOTICE))
{
    string sMessage = MyExpensiveFunction();
    Debug(sMessage);
}
```
