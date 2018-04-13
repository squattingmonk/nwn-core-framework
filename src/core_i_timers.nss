// -----------------------------------------------------------------------------
//    File: core_i_timers.nss
//  System: Core Framework (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds functions for creating and managing timers, events that fire
// at regular intervals.
// -----------------------------------------------------------------------------

#include "core_i_constants"
#include "core_i_events"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< CreateTimer >---
// ---< core_i_timers >---
// Creates a timer and returns an integer representing its unique ID. After a
// timer is created you will need to start it to get it to run. You cannot
// create a timer on an invalid target or with a non-positive interval
// value. A returned timer ID of 0 means the timer was not created.
// Parameters:
// - oTarget: the object sScriptName will run on.
// - sEvent: the name of the event that will fire when the set time has elapsed
// - fInterval: the number of seconds before sEvent executes.
// - nIterations: the number of times to the timer can elapse. 0 means no limit.
//   If this is 0, fInterval must be greater than 6.0.
// - nJitter: add a bit of randomness to how often a timer executes. A random
//   number of seconds between 0 and nJitter will  be added to fInterval each
//   time the event runs. Leave this at the default value of 0 for no jitter.
// Note: Save the returned timer ID somewhere so that it can be accessed and
// used to stop, start, or kill the timer later. If oTarget has become invalid
// or if oTarget was a PC and that PC has logged off, then instead of executing
// the timer event, it will kill the timer.
int CreateTimer(object oTarget, string sEvent, float fInterval, int nIterations = 0, int nJitter = 0);

// ---< GetIsTimerValid >---
// ---< core_i_timers >---
// Returns whether the timer with ID nTimerID exists.
int GetIsTimerValid(int nTimerID);

// ---< StartTimer >---
// ---< core_i_timers >---
// Starts a timer, executing its event immediately if bInstant is TRUE, and
// again each interval period until finished iterating, stopped, or killed.
void StartTimer(int nTimerID, int bInstant = TRUE);

// ---< StopTimer >---
// ---< core_i_timers >---
// Suspends execution of the timer script associated with the value of nTimerID.
// This does not kill the timer, only stops its event from being executed.
void StopTimer(int nTimerID);

// ---< KillTimer >---
// ---< core_i_timers >---
// Kills the timer associated with the value of nTimerID. This results in all
// information about the given timer ID being deleted. Since the information is
// gone, the event associated with that timer ID will not get executed again.
void KillTimer(int nTimerID);

// ---< ResetTimer >---
// ---< core_i_timers >---
// Resets the number of remaining iterations on the timer associated with
// nTimerID.
void ResetTimer(int nTimerID);

// ---< GetCurrentTimer >---
// ---< core_i_timers >---
// Returns the ID of the timer executing the current script. Useful if you want
// to be able to reset or stop the timer that triggered the script.
int GetCurrentTimer();


// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int CreateTimer(object oTarget, string sEvent, float fInterval, int nIterations = 0, int nJitter = 0)
{
    Debug("Creating timer " + sEvent + " on " + GetName(oTarget) +
          ": fInterval="   + FloatToString(fInterval) +
          ", nIterations=" + IntToString(nIterations) +
          ", nJitter="     + IntToString(nJitter));

    // Sanity checks: don't create the timer if...
    // 1. the target is invalid
    // 2. the interval is not greater than 0.0
    // 3. the number of iterations is non-positive
    // 4. the interval is more than once per round and the timer is infinite
    string sError;
    if (!GetIsObjectValid(oTarget))
        sError = "oTarget is invalid";
    else if (fInterval <= 0.0)
        sError = "fInterval is negative";
    else if (nIterations < 0)
        sError = "nIterations is negative";
    else if (fInterval < 6.0 && !nIterations)
        sError = "fInterval is too short for infinite executions";

    if (sError != "")
    {
        Debug("Cannot create timer " + sEvent + ": " + sError, DEBUG_LEVEL_CRITICAL);
        return 0;
    }

    int nTimerID = GetLocalInt(TIMERS, TIMER_NEXT_ID);
    string sTimerID = IntToString(nTimerID);

    SetLocalString(TIMERS, TIMER_EVENT       + sTimerID, sEvent);
    SetLocalObject(TIMERS, TIMER_TARGET      + sTimerID, oTarget);
    SetLocalFloat (TIMERS, TIMER_INTERVAL    + sTimerID, fInterval);
    SetLocalInt   (TIMERS, TIMER_JITTER      + sTimerID, abs(nJitter));
    SetLocalInt   (TIMERS, TIMER_ITERATIONS  + sTimerID, nIterations);
    SetLocalInt   (TIMERS, TIMER_REMAINING   + sTimerID, nIterations);
    SetLocalInt   (TIMERS, TIMER_TARGETS_PC  + sTimerID, GetIsPC(oTarget));
    SetLocalInt   (TIMERS, TIMER_EXISTS      + sTimerID, TRUE);
    SetLocalInt   (TIMERS, TIMER_NEXT_ID,      nTimerID + 1);

    Debug("Successfully created new timer with ID=" + sTimerID);
    return nTimerID;
}

int GetIsTimerValid(int nTimerID)
{
    // Timer IDs less than or equal to 0 are always invalid.
    return (nTimerID > 0) && GetLocalInt(TIMERS, TIMER_EXISTS + IntToString(nTimerID));
}

// Private function used by StartTimer().
void _TimerElapsed(int nTimerID, int bFirstRun = FALSE)
{
    string sError, sTimerID = IntToString(nTimerID);
    object oTarget = GetLocalObject(TIMERS, TIMER_TARGET + sTimerID);
    string sEvent = GetLocalString(TIMERS, TIMER_EVENT + sTimerID);
    Debug("Timer elapsed: nTimerID=" + sTimerID + " bFirstRun=" + IntToString(bFirstRun));

    // Sanity checks: make sure...
    // 1. the timer still exists
    // 2. the timer has been started
    // 3. the timer target is still valid
    // 4. the timer target is still a PC if it was originally (usually this only
    //    changes due to a PC logging out.
    if (!GetLocalInt(TIMERS, TIMER_EXISTS + sTimerID))
        sError = "Timer no longer exists. Running cleanup...";
    else if (!GetLocalInt(TIMERS, TIMER_RUNNING + sTimerID))
        sError = "Timer has not been started";
    else if (!GetIsObjectValid(oTarget))
        sError = "Timer target is no longer valid. Running cleanup...";
    else if (GetLocalInt(TIMERS, TIMER_TARGETS_PC + sTimerID) && !GetIsPC(oTarget))
        sError = "Timer target used to be a PC but now is not";

    if (sError != "")
    {
        Debug("Cannot execute timer " + sEvent + ": " + sError, DEBUG_LEVEL_WARNING);
        KillTimer(nTimerID);
    }

    // Check how many more times the timer should be run
    int nIterations = GetLocalInt(TIMERS, TIMER_ITERATIONS + sTimerID);
    int nRemaining  = GetLocalInt(TIMERS, TIMER_REMAINING  + sTimerID);

    // If we're running infinitely or we have more runs remaining...
    if (!nIterations || nRemaining)
    {
        if (!bFirstRun)
        {
            // If we're not running an infinite number of times, decrement the
            // number of iterations we have remaining
            if (nIterations)
                SetLocalInt(TIMERS, TIMER_REMAINING + sTimerID, nRemaining - 1);

            // Add the timer to a list of currently executing timer IDs. The
            // most recent list item is the one that will be retrieved by
            // GetCurrentTimer(). We do this so any scripts that execute their
            // own timers won't throw us off.
            int nCount = CountIntList(TIMERS);
            AddListInt(TIMERS, nTimerID);

            // Run the event hook
            RunEvent(sEvent, OBJECT_INVALID, oTarget);

            // Remove the timer from the current list
            DeleteListInt(TIMERS, nCount);

            // In case one of those scripts we just called reset the timer...
            if (nIterations)
                nRemaining = GetLocalInt(TIMERS, TIMER_REMAINING  + sTimerID);
        }

        // If we have runs left, call our timer's next iteration.
        if (!nIterations || nRemaining)
        {
            // Account for any jitter
            int   nJitter        = GetLocalInt  (TIMERS, TIMER_JITTER);
            float fTimerInterval = GetLocalFloat(TIMERS, TIMER_INTERVAL + sTimerID) +
                                   IntToFloat(Random(nJitter + 1));

            if (IsDebugging(DEBUG_LEVEL_NOTICE))
            {
                Debug("Calling next iteration of timer " + sTimerID + " in " +
                      FloatToString(fTimerInterval) + " seconds. Runs remaining: " +
                      (nIterations ? IntToString(nRemaining) : "Infinite"));
            }

            DelayCommand(fTimerInterval, _TimerElapsed(nTimerID));
            return;
        }
    }

    // We have no more runs left! Kill the timer to clean up.
    Debug("No more runs remaining on timer " + sTimerID + ". Running cleanup...");
    KillTimer(nTimerID);
}

void StartTimer(int nTimerID, int bInstant = TRUE)
{
    string sTimerID = IntToString(nTimerID);

    if (GetLocalInt(TIMERS, TIMER_RUNNING + sTimerID))
    {
        Debug("Could not start timer " + sTimerID + " because it was already started.");
        return;
    }

    SetLocalInt(TIMERS, TIMER_RUNNING + sTimerID, TRUE);
    _TimerElapsed(nTimerID, !bInstant);
}

void StopTimer(int nTimerID)
{
    string sTimerID = IntToString(nTimerID);
    DeleteLocalInt(TIMERS, TIMER_RUNNING + sTimerID);
}

void ResetTimer(int nTimerID)
{
    string sTimerID = IntToString(nTimerID);
    int nRemaining  = GetLocalInt(TIMERS, TIMER_ITERATIONS + sTimerID);
                      SetLocalInt(TIMERS, TIMER_REMAINING  + sTimerID, nRemaining);

    Debug("Resetting remaining iterations of timer " + sTimerID +
          " to " + IntToString(nRemaining));
}

void KillTimer(int nTimerID)
{
    string sTimerID = IntToString(nTimerID);

    // Cleanup the local variables
    DeleteLocalString(TIMERS, TIMER_EVENT       + sTimerID);
    DeleteLocalObject(TIMERS, TIMER_TARGET      + sTimerID);
    DeleteLocalFloat (TIMERS, TIMER_INTERVAL    + sTimerID);
    DeleteLocalInt   (TIMERS, TIMER_ITERATIONS  + sTimerID);
    DeleteLocalInt   (TIMERS, TIMER_REMAINING   + sTimerID);
    DeleteLocalInt   (TIMERS, TIMER_TARGETS_PC  + sTimerID);
    DeleteLocalInt   (TIMERS, TIMER_RUNNING     + sTimerID);
    DeleteLocalInt   (TIMERS, TIMER_EXISTS      + sTimerID);
}

int GetCurrentTimer()
{
    int nCount = CountIntList(TIMERS);
    return GetListInt(TIMERS, nCount - 1);
}
