# Database Component Configurator Container Builder

This project locally builds an optimized docker image containing the database configurator only.

The intention is to use the image to create or upgrade webMethods database schemas on demand, keeping the DBC occupying resources only for the duration of the change run. This may be achieved 100% programatically, thus achieveing perfect repeatability and control.

A secondary use case is quickly and dinamically setup database schemas in ephemeral environments.

## Requirements

- wm-install-helper built (..\01.build.001.wm-install-helper\build.bat)
- SUM credentials if pathing occurs online (see ../config/secret/readme.md)

## Usage

- edit .env and provide all your local paths. All of them are required
- run build.bat
- eventually alter build.v1003.bat specifying valid local paths for the parameters and run it

## TODO

- upgrade to .env file generation