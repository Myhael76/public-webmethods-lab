# MWS installation scripts

## bpm-set-1.wmscript.txt

MWS instalation without creation of an instance at install time

## set2

Products selected:

```bash
My webMethods Server
  Server 10.5
  Business Administration 10.5
  Business Console 10.5
  Diagnostic Tools 10.5
  Task Engine 10.5
My webMethods User Interfaces
  Business Console UI 10.5
  Business Rules UI 10.5
  Central Configuration UI 10.5
  Integration Server UI 10.5
  Monitor UI 10.5
  Optimize for Process UI 10.5
```

Choices made:

|Choice|Value|
|-|-|
|hostname|localhost|
|installation type|New Installation|
|database type|MySQL Community Edition|
|database url|jdbc:mysql://mysql:3306/webmethods|
|database user|webmethods|
|database password|webmethods|
|create instance|yes|
|instance name|default|
|use Command Central|No|
|Business Rules license file|/opt/sag/mnt/wm-install-files/licenses/br.xml|