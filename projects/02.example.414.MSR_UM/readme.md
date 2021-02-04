# Project 414 - Minimum MSR + UM Development Stack

## Prerequisites

IMPORTANT: cloning this project requires that line feeds in the files are unix stile, therefore set your git client for input autocrlf

```bat
git config --global core.autocrlf input
```

This project is proposed also as an example of single command start after cloning. As for this moment, the product and fix image creation automation is still WIP, therefore, the prereqisites are:

- installer binary for linux 
- update manager bootstrap for linux version 11
  - Note: due to genericity of the commons, the first command will also ask for the location of v10. Leave it blank (cancel) or provide any file, it will not be used by this project, however the choice is memorized in the commons folder, therefore it is recommneded to provide the v10 bootstrap too
- appropriate products image produced upfront with another installer (automation WIP)
- appropriate fix image produced upfront with another SUM (automation WIP)
- license for MSR
- license for UM
- Note: these two licenses have to be provided twice, once for building, once for running. Diferent licenses may be used for different phases

## Quickstart

- Ensure the prerequisites are fulfilled
- Clone the Github project
- Run 00.quickStartAllOneTime.bat for the first time. It will take about 20 minutes or more depending on the speed of your computer, network link and docker images that are already present (centos:7)
- For all subsequent needs:

```bat
:: Project close
docker-compose down

:: Project start
docker-compose up
```
