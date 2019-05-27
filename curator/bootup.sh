#!/bin/sh
 
echo "Starting bootup process..."
 
echo " "
echo "Copying config files..."
cp /var/curator/config.yaml /curator/config.yaml
cp /var/curator/actions.yaml /curator/actions.yaml
 
echo " "
echo "Replacing vars..."
sed -i "s/##-ELASTIC_URL-##/$ELASTIC_URL/g" /curator/config.yaml
sed -i "s/##-ELASTIC_PASSWORD-##/$ELASTIC_PASSWORD/g" /curator/config.yaml
sed -i "s/##-ELASTIC_USER-##/$ELASTIC_USER/g" /curator/config.yaml
 
echo " "
echo "Calling curator..."
/usr/local/bin/curator --config /curator/config.yaml $@ /curator/actions.yaml
