# Core Framework

This project is a framework for managing a [Neverwinter 
Nights](https://neverwintervault.org) module.

This system is in alpha. Things will change and will break. You have been 
warned.

## Prerequisites
- [nwnsc](https://gitlab.com/glorwinger/nwnsc)
- [nwn-lib](https://github.com/niv/nwn-lib)
- [nwn-packer](https://github.com/squattingmonk/nwn-packer)

## Installation
Get the code:
```
git clone https://github.com/squattingmonk/nwn-core-framework --recurse-submodules
```

Run the build script:
```
cd nwn-core-framework
rake install
```

The erf will be placed into your Neverwinter Nights install directory in the 
/erf folder. From there you can use the toolset to import it into your module. 

Alternatively, you may build the demo module by running the following:
```
cd nwn-core-framework
rake demo:install
```

The module will be placed into your Neverwinter Nights install directory in the 
/mod folder.
