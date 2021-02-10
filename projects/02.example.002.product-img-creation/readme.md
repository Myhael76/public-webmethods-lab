# Project 02.example.002.product-img-creation

## Purpose

This project automates the creation of the product image for the current repo.

## Prerequisites

1. Empower credentials
2. Software AG installer binary manually downloaded from Software aG Download center

## Quick start

1. Execute 01.generateEnv.bat
   1. You will be asked what is the destination folder for the image and where the installer is
2. (Eventually) refresh the wmscript file by running 02.01.default.createScriptFile_LNXAMD64_10.5.bat
   1. This part is computing all the products mentioned in this repository for the parametrized version
3. Run 03.01.default.produceFixesImage.bat
   1. If other products lists are needed, clone this bat.file and provide your own wmscript

Images may be produced for other platforms too, observe the "example" bat files.

## Current status

Works with 1005, but not with 1003.