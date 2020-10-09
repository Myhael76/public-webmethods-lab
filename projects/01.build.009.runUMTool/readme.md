# runUMTool Container Builder

This project locally builds an optimized docker image containing the runUMTool only.

The intention is to use the image to alter remote Universal Messaging realms on demand, keeping the resources only for the duration of the change run. This may be achieved 100% programatically, thus achieveing perfect repeatability and control.

An example use case is creation of a JNDI configuration containing a service name that is not resolvable from the Realm Machine itself

## Requirements

- project 00.commons
- project 01.build.000.commons

## Usage

- run build.bat
