#!/bin/sh
# Xray generate configuration
# Download and install Xray
TMP_DIR="/tmp/xray"
config_path=$PROTOCOL"_ws_tls.json"
DOWNLOAD_LINK="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip"
mkdir "$TMP_DIR"
curl -L -H "Cache-Control: no-cache" -o "${TMP_DIR}/xray.zip" "$DOWNLOAD_LINK"
unzip "${TMP_DIR}/xray.zip" -d "$TMP_DIR"
install -m 755 "${TMP_DIR}/xray" /usr/local/bin/xray
install -m 644 "${TMP_DIR}/geoip.dat" /usr/local/share/xray
install -m 644 "${TMP_DIR}/geosite.dat" /usr/local/share/xray
# Remove temporary directory
rm -rf "$TMP_DIR"
# xray new configuration
install -d /usr/local/etc/xray
envsubst '\$UUID,\$WS_PATH' < $config_path > /usr/local/etc/xray/config.json

# Run xray
/usr/local/bin/xray -config /usr/local/etc/xray/config.json &
# Run nginx
/bin/bash -c "envsubst '\$PORT,\$WS_PATH' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'