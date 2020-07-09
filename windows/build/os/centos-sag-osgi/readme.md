# CENTOS:7 based Software AG OSGI Base Image

This image will be used for all Software AG installations where the common osgi framework makes the installation folder too variable to be copied over as a docker layer.

## Conventions

|Folder                            |Description                       |
|----------------------------------|----------------------------------|
|/opt/sag                          | Home folder for user sagadmin|
|/opt/sag/products                 | Installation folder, will be used as a resilient mount |
|/opt/sag/sum                      | Update Manager home, will be used as a volatile mount  |
|/opt/sag/osgi-orchestrator | script mount (dev) or copied over|
|/opt/sag/mnt/wm-install-files     | will contain installation related assets, with the convention below|

### Installation Related File Names
- products.zip
- fixes.zip
- installer.bin
- sum-bootstrap.bin
- lic/br.xml
- lic/msr.xml
- lic/um.xml
- lic/is.xml

To continue