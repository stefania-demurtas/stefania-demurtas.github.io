#!/bin/sh

# Bower installs packages to bower_components/ directory
# Bower keeps track of these packages in a manifest file, 'bower.json'.
bower install

# The app.build.js is a computed configuration
# Since r.js is not designed to execute what it passed to mainConfigFile,
# the following code will create a configuration file which is not computed.
MAIN_FILE=src/js/main.js
MAIN_FILE_BKP=$MAIN_FILE'.bkp'
cp $MAIN_FILE $MAIN_FILE_BKP
VENDOR_VAR='vendorDir'
VENDOR_DIR="$(more $MAIN_FILE |grep $VENDOR_VAR' =' |awk '{print $4}' | sed "s/';$//")"
sed s:"$VENDOR_VAR + '":"$VENDOR_DIR": $MAIN_FILE_BKP > $MAIN_FILE


# Run the optimizer passing the build profile's file name 'app.build.js' and 'app.build.css'
# The optimizer will create two files name: 'src/js/main.min.js' and 'src/css/main.min.css'
cd src/js
node  ../../bower_components/r.js/dist/r.js -o app.build.js
cd -

# Remove the packages after running the optimize
rm -rf bower_components
# Restore the app.build.js from a not computed to a computed configuration
mv $MAIN_FILE_BKP $MAIN_FILE
