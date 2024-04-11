# Core Framework Concept: Events
The Core Framework handles event management for an entire module. It will
source, classify, prioritize, and run scripts for any event that can be defined.
This includes base NWN events (such as `OnPlayerDeath` and `OnModuleLoad`), NWNX
events (such as `NWNX_ON_REMOVE_ASSOCIATE_BEFORE`), or user-defined (say,
`OnPlayerRegistered`). Scripts can subscribe to these events and be run when the
event is triggered.

## Event Hook Scripts
The framework intercepts game events with hook scripts. The hook script
determines the event that is running and executes an event queue which calls all
subscribed scripts in order of [priority](#script-priorities).

The hook script for the base game events is `hook_nwn.nss`; it is placed in the
script slot for all object events. The hook script for NWNX events is
`hook_nwnx.nss`; it does not need to be placed in an event slot.

Custom events can be triggered using the `RunEvent()` function and giving it the
name of the event to run. This is how the custom events `OnHour` and
`OnAreaEmpty` are handled.

## Registering Event Scripts
A script can subscribe to an event using the `RegisterEventScript()` function.
This function takes the [object to register the script on](#script-sources), the
event to subscribe to, a [library script][libraries] to execute, and the
[priority](#script-priorities) for the script.

Events are referred to using a string name. For the module events, these event
names are the same as the game uses (i.e., `OnModuleLoad`, `OnClientEnter`,
etc.). Other objects use the object type in their name to avoid ambiguity (for
example, `OnAreaEnter` and `OnTriggerEnter` refer to the game's `OnEnter` event
for areas and triggers, respectively). Event names are provided for all base
game events for the module, AoEs, areas, doors, encounters, placeables, stores,
triggers, traps, and creatures. PCs also have their own creature events that use
the prefix `OnPC*` instead of `OnCreature*`.

Scripts can also be registered using the `RegisterPluginScripts()` function.
This function takes the [object to register the script on](#script-sources) and
a CSV list of glob patterns matching nss filenames.  This function requires
a specified decorator be applied to each event script in a script library.
The decorator must reside in a comment immediately preceding the specific
function and must contain the following:

- Decorator (required):  `@EVENT[...]`
- Event Reference (required):  `OnModuleLoad`
- [Priority](#script-priorities) (optional)

Example decorators:

```c
// @EVENT[OnModuleLoad:first]
void pw_OnModuleLoad() {...}

// @EVENT[OnPlayerDeath]
void pw_OnPlayerDeath() {...}

// @EVENT[OnPlayerChat:3.0]
void pw_OnPlayerChat() {...}
```

While registering scripts decorated with `@EVENT[...]`, `RegisterPluginScripts()`
will also register any library scripts decorated with `@LIBRARY[]` in script
libraries matching the given glob patterns.

## Script Sources
Since scripts are not placed directly into an object's event script slots, the
framework needs to know what scripts should be run for an event. There are
several possibilities:

### Global Event Scripts
Global event scripts are those which are registered to an event by a plugin.
They are called for any object when its event of that name is triggered. For
example, an XP plugin might register an `OnCreatureDeath` script that rewards XP
to a PC that killed the creature. That script would then fire on any creature
when it dies.

### Local Event Scripts
Local event scripts are those which are registered to an event by a non-plugin
object. Local event scripts fire only on the objects which register them. For
example, a creature might register an `OnCreatureDeath` script that causes it to
explode when it dies. This script will only be called on that particular
creature's death.

Local event scripts are usually sourced from the object executing the event, but
they can come from other objects as well. Using `AddScriptSource()`, an object
can be added as a source of local event scripts for another object. For example,
an area can register an `OnCreatureDeath` script that causes a dead creature to
rise as a zombie. If the area is added as a script source for a creature (the
framework does this during the `OnAreaEnter` event, but it can also be done
manually), the creature will then execute that script when it dies.

### Tag-Based Scripts
Tag-based scripting has been extended to all events instead of only module-level
items events. All events execute a [library script][libraries] matching
`OBJECT_SELF`'s tag. This script does not need to be registered to the event and
will always be run after any registered scripts.

## Script Priorities
When a script is registered to an event, it is given a priority. The priority
decides the order in which scripts run when the event is triggered. Priorities
range from `0.0` to `10.0`. The default priority assigned to [global event
scripts](#global-event-scripts) is `5.0`, while the defailt priority assigned to
[local event scripts](#local-event-scripts) is `7.0`. There are also several
special priorities:

- `first`: The script will always run first. If multiple scripts have this
  priority, they will run in the order registered.
- `last`: The script will always run last. If multiple scripts have this
  priority, they will run in the order registered.
- `only`: The script will run and no others will run afterwards. If multiple
  scripts have this priority, only the first one registered will run.
- `default`: The script will run only if no others have run. If multiple scripts
  have this priority, only the first one registered will run.

## Event States
Each script that runs during an event can change the state of the event using
`SetEventState()`. This function takes a bitmask of three possible event states:

- `EVENT_STATE_OK`: This is the default event state. During this state, event
  scripts will continue processing in order.
- `EVENT_STATE_ABORT`: This state stops remaining scripts in the event's queue
  from running.
- `EVENT_STATE_DENIED`: The state signals to the system that special behavior
  should be performed to stop the event. Handling is dependent on the event (and
  not all events support it). For example, the `OnClientEnter` event will boot
  the PC, while the `OnPlayerChat` event will suppress the chat attempt.
  Regardless of the event type, the `DENIED` state will prevent tag-based
  scripts from firing after an event queue is complete.

Event states allow scripts earlier in the event's queue to prevent later scripts
from firing if certain criteria are met. For example, an `OnPlayerRestStarted`
script might check if the PC meets requirements for resting in an area. If not,
it can set the event state to `EVENT_STATE_ABORT | EVENT_STATE_DENIED` to stop
remaining `OnPlayerRestStarted` scripts from running and to stop the player from
resting.

[libraries]: https://github.com/squattingmonk/sm-utils/blob/master/docs/libraries.md
