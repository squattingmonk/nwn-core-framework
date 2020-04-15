/*
Filename:           h2_timers_i
System:             core (timer functions include script)
Author:             Edward Beck (0100010)
Date Created:       Jan. 28, 2006
Summary:
HCR2 core constants and functions for the Timer system.
Used throughout the core HCR2 system.

Revision Info should only be included for post-release revisions.
-----------------
Revision Date: Dec 31st, 2006
Revision Author: Edward Beck (0100010)
Revision Summary: v1.5
Altered timers to not be reliant on the heartbeat event.
Instead they use looping delayed commands.
-----------------
Revision Date:  20200203
Revision Author:  Edward Burke (tinygiant)
Revision Summary:  v1.6
Modified entire library to allow custom use by the Dark Sun module.
Created a structured variable to hold additional members beyond the basic three
	originally found in the scripts.
	- RunScriptOnStart - Option to run a script immediately when the timer is started or
		wait for the first interval to expire.
	- IsRunning - Moved H2_TIMER_IS_RUNNING to the timer object to prevent inadvertant
		timer cancellations when more than one timer is running on the same object.
	- RepititionCount - Option to limit the number of times a script is run on this timer.  If
		this parameter is 0, the timer will run indefinitely to preserver original programming intent.
	- ExecutionCount - Number of times the referenced sScriptName has been executed with this timer.
	- ObjectIsPC - Flags whether the script object is a PC or some other game object.
Added routines to handle the structured variable (h2_SaveTimerVariables, h2_GetTimerVariables,
	h2_DeleteTimerVariables).
Added appropriate constants added to h2_constants_i.
Added optional parameters to h2_CreateTimer(), which allows legacy code to continue using the timers
	while allowing the new modifications to run correctly.  If calls requesting new features do not
	include the optional parameters, the timers will run as originally programmed.
Added function prototypes for the functions meant to be called from external sources.
Reorganized to have unprototyped internal functions on top and prototyped external functions on bottom.
-----------------
*/

#include "h2_locals_i"

//This structured variable holds all of the timer members.  Structured variables cannot be saved on
//	objects in NWN, so this is used as a convenient reference when it makes it easier from a
//	programming perspective.  Otherwise, the variables are referenced directly from the functions.
struct strTimer 
{
	int ID;
	object ScriptObject;
	string ScriptName;
	float Interval;
	int RunScriptOnStart;
	int ExecutionCount;
	int RepititionCount;
	int IsRunning;
	int ObjectIsPC;
};

//This function creates the variables necessary to utilize the requested timer.  You must call
//	this function with an oScriptObject, an sScriptName and an fInterval.  Optionally, you can send
//	a bRunScriptOnStart and nRepititionCount.
//This function will return a unique ID that is associated with this timer.  After you create the timer,
//	you should save the returned timerID so you can later start, stop or kill the timer, if the timer
//	isn't automatically killed by this include.
//If you send 0 as the nRepititionCount, the timer will run indefinitely, until you kill it from another
//	script or the oScriptObject becomes invalid.  If you send anything greater than 0, the timer will run
//	until the script has been executed the desired number of times, then the timer will be killed.  If you
//	saved the timerID somewhere and created a timer with a limited number of executions, ensure you
//	destroy that variable at some point to prevent calling timer functions with an invalid timerID.
//This functions returns a timerID of 0 if there's an error.  Enesure you check for this error before using
//	the timer.
int h2_CreateTimer(object oScriptObject, string sScriptName, float fInterval, int bRunScriptOnStart = TRUE, int nRepititionCount = 0);

//This function starts the timer and, if requested, fires the script immediately.  If the execution
//	count is greater than 0, then the script has already been run once and the request to execute on
//	start is ignored.  This covers the case in which a timer is run, executed on start, stopped, then
//	started again.
void h2_StartTimer(int nTimerID);

//This function will stop execution of the timer by setting the IsRunning flag to false.  This does
//	not kill the timer and the DelayCommand will still run to completion.  When the timer is started
//	again, the original delay will be used until the script is executed or the timer is killed.  If the
//	original delay has already passed, a new interval period will begin.
void h2_StopTimer(int nTimerID);

//This function will delete all of the variables associated with nTimerID.  The DelayCommand to execute
//	the associated script still exists and is counting down, so when that timer expires and the
//	script checks for object validity, the script associated with the timer will not run.  Once a timer
//	is killed, any objects carrying the timerID must have that variable deleted to prevent future errors
//	with invalid timerIDs.
void h2_KillTimer(int nTimerID);

//This function creates all of the timer variables created when the timer was created.  This function
//	is meant for internal use only and does not contain any error-checking.
void h2_SaveTimerVariables(struct strTimer tmr)
{
	h2_SetModLocalString(H2_TIMER_SCRIPT + IntToString(tmr.ID), tmr.ScriptName);
    h2_SetModLocalObject(H2_TIMER_OBJECT + IntToString(tmr.ID), tmr.ScriptObject);
	h2_SetModLocalFloat(H2_TIMER_INTERVAL + IntToString(tmr.ID), tmr.Interval);
	h2_SetModLocalInt(H2_TIMER_RUN_SCRIPT_ON_START + IntToString(tmr.ID), tmr.RunScriptOnStart);
	h2_SetModLocalInt(H2_TIMER_IS_RUNNING + IntToString(tmr.ID), tmr.IsRunning);
	h2_SetModLocalInt(H2_TIMER_REPITITION_COUNT + IntToString(tmr.ID), tmr.RepititionCount);
	h2_SetModLocalInt(H2_TIMER_EXECUTION_COUNT + IntToString(tmr.ID), tmr.ExecutionCount);
	h2_SetModLocalInt(H2_TIMER_OBJECT_IS_PC + IntToString(tmr.ID), tmr.ObjectIsPC);
}

//This function returns all of the timer variables created when the timer was created.  This function
//	is meant for internal use only and does not contain any error-checking.
struct strTimer h2_GetTimerVariables(int nTimerID)
{
	struct strTimer tmr;

	tmr.ID = nTimerID;
	tmr.ScriptObject = h2_GetModLocalObject(H2_TIMER_OBJECT + IntToString(tmr.ID));
	tmr.ScriptName = h2_GetModLocalString(H2_TIMER_SCRIPT + IntToString(tmr.ID));
	tmr.Interval = h2_GetModLocalFloat(H2_TIMER_INTERVAL + IntToString(tmr.ID));
	tmr.RunScriptOnStart = h2_GetModLocalInt(H2_TIMER_RUN_SCRIPT_ON_START + IntToString(tmr.ID));
	tmr.RepititionCount = h2_GetModLocalInt(H2_TIMER_REPITITION_COUNT + IntToString(tmr.ID));
	tmr.ExecutionCount = h2_GetModLocalInt(H2_TIMER_EXECUTION_COUNT + IntToString(tmr.ID));
	tmr.IsRunning = h2_GetModLocalInt(H2_TIMER_IS_RUNNING + IntToString(tmr.ID));
	tmr.ObjectIsPC = h2_GetModLocalInt(H2_TIMER_OBJECT_IS_PC + IntToString(tmr.ID));

	return tmr;
}

//This function deletes all of the timer variables created when the timer was created.  This function
//	is meant for internal use only and does not contain any error-checking.
void h2_DeleteTimerVariables(int nTimerID)
{
	h2_DeleteModLocalObject(H2_TIMER_OBJECT + IntToString(nTimerID));
	h2_DeleteModLocalString(H2_TIMER_SCRIPT + IntToString(nTimerID));
	h2_DeleteModLocalFloat(H2_TIMER_INTERVAL + IntToString(nTimerID));
	h2_DeleteModLocalInt(H2_TIMER_RUN_SCRIPT_ON_START + IntToString(nTimerID));
	h2_DeleteModLocalInt(H2_TIMER_REPITITION_COUNT + IntToString(nTimerID));
	h2_DeleteModLocalInt(H2_TIMER_EXECUTION_COUNT + IntToString(nTimerID));
	h2_DeleteModLocalInt(H2_TIMER_IS_RUNNING + IntToString(nTimerID));
	h2_DeleteModLocalInt(H2_TIMER_OBJECT_IS_PC + IntToString(nTimerID));
}

//This runs when the interval associated with the timer of nTimerID elapses.  If the requested
//	number of repititions has been met, the timer is killed.  Even though the timer is killed after the
//	set number of repititions, a variable might still remain in another script with the timerID.  This
//	function is meant for internal use only.
void h2_TimerElapsed(int nTimerID)
{
	struct strTimer tmr = h2_GetTimerVariables(nTimerID);

	if (GetIsObjectValid(tmr.ScriptObject) && tmr.Interval > 0.0)
	{
		if (!tmr.IsRunning)
			return;

		if ((tmr.ObjectIsPC) && !GetIsPC(tmr.ScriptObject))
		{
			h2_KillTimer(nTimerID);
			return;
		}

		if ((tmr.RepititionCount == 0) ||
			(tmr.ExecutionCount < tmr.RepititionCount))
		{
			ExecuteScript(tmr.ScriptName, tmr.ScriptObject);
			h2_SetModLocalInt(H2_TIMER_EXECUTION_COUNT + IntToString(tmr.ID), tmr.ExecutionCount + 1);
			DelayCommand(tmr.Interval, h2_TimerElapsed(tmr.ID));
		}
		else
			h2_KillTimer(tmr.ID);
	}
	else
		h2_KillTimer(tmr.ID);
}

int h2_CreateTimer(object oScriptObject, string sScriptName, float fInterval, int bRunScriptOnStart = TRUE, int nRepititionCount = 0)
{
	struct strTimer tmr;

	if (!GetIsObjectValid(oScriptObject))
	{
		string sMessage  = "Warning cannot create " + sScriptName + " timer on invalid script object.";
		SendMessageToAllDMs(sMessage);
		WriteTimestampedLogEntry(sMessage);
		return 0;
	}

	if (fInterval <= 0.0)
	{
		string sMessage  = "Warning cannot create " + sScriptName + " timer with interval of " + FloatToString(fInterval);
		SendMessageToAllDMs(sMessage);
		WriteTimestampedLogEntry(sMessage);
		return 0;
	}

	if (nRepititionCount < 0)
	{
		string sMessage = "Warning cannot create " + sScriptName + " timer with a repitition count of " + IntToString(nRepititionCount);
		SendMessageToAllDMs(sMessage);
		WriteTimestampedLogEntry(sMessage);
		return 0;
	}

    int nTimerID = h2_GetModLocalInt(H2_NEXT_TIMER_ID);
    h2_SetModLocalInt(H2_NEXT_TIMER_ID, nTimerID + 1);

	tmr.ID = nTimerID;
	tmr.ScriptObject = oScriptObject;
	tmr.ScriptName = sScriptName;
	tmr.Interval = fInterval;
	tmr.RunScriptOnStart = bRunScriptOnStart;
	tmr.RepititionCount = nRepititionCount;
	tmr.ExecutionCount = 0;
	tmr.IsRunning = FALSE;
	tmr.ObjectIsPC = (GetIsPC(oScriptObject));

	h2_SaveTimerVariables(tmr);
	return tmr.ID;
}

void h2_StartTimer(int nTimerID)
{
	h2_SetModLocalInt(H2_TIMER_IS_RUNNING + IntToString(nTimerID), TRUE);

	if ((h2_GetModLocalInt(H2_TIMER_RUN_SCRIPT_ON_START + IntToString(nTimerID))) &&
		(h2_GetModLocalInt(H2_TIMER_EXECUTION_COUNT + IntToString(nTimerID)) == 0))
	        h2_TimerElapsed(nTimerID);
        else
            DelayCommand(h2_GetModLocalFloat(H2_TIMER_INTERVAL + IntToString(nTimerID)), h2_TimerElapsed(nTimerID));
}

void h2_StopTimer(int nTimerID)
{
	h2_SetModLocalInt(H2_TIMER_IS_RUNNING + IntToString(nTimerID), FALSE);
}

void h2_KillTimer(int nTimerID)
{
    h2_DeleteTimerVariables(nTimerID);
}
