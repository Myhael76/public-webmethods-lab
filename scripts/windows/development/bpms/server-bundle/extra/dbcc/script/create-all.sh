#!/bin/sh

cd /opt/softwareag/common/db/bin/

./dbConfigurator.sh \
    --action create \
    --dbms mysql \
    --url "jdbc:mysql://mysql:3306/webmethods?useSSL=false" \
    --component All \
    --user "webmethods" \
    --password "webmethods" \
    --version latest \
    --printActions

