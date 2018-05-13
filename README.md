# Core Framework

This project is a framework for managing a [Neverwinter 
Nights](https://neverwintervault.org) module.

This system is in alpha. Things will change and will break. You have been 
warned.

## Prerequisites
- [sm-utils](https://github.com/squattingmonk/sm-utils)
- [nwnsc](https://gitlab.com/glorwinger/nwnsc)
- [nwn-lib](https://github.com/niv/nwn-tools)
- Ruby and rake to run the install script

## Installation
Get the code:
```
git clone https://github.com/squattingmonk/nwn-core-framework --recurse-submodules
```

Run the build script:
```
cd nwn-core-framework
rake pack
```

The erf will be placed into the nwn-core-framework directory. You can copy it 
to your NWN installation's /erf directory and then import it into your module.

Alternatively, you may build the demo module by running the following:
```
cd nwn-core-framework
rake demo:pack
```

The mod will be placed into the nwn-core-framework directory. You can copy it 
to your NWN installation's /modules directory and then import it into your 
module.
