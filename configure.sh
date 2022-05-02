#!/bin/sh
# Xray generate configuration
# Download and install Xray
tmp_dir="/tmp/xray"
config_path=$PROTOCOL"_ws_tls.json"
geodata_dir='/usr/local/share/xray'
download_link_xray="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip"
download_link_geoip="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
download_link_geosite="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
mkdir "$tmp_dir"
curl -L -H "Cache-Control: no-cache" -o "${tmp_dir}/xray.zip" "$download_link_xray"
unzip "${tmp_dir}/xray.zip" -d "$tmp_dir"
install -m 755 "${tmp_dir}/xray" /usr/local/bin/xray
install -m 644 "${tmp_dir}/geoip.dat" "$geodata_dir"
install -m 644 "${tmp_dir}/geosite.dat" "$geodata_dir"
rm -r "${geodata_dir}/*.dat"
curl -H 'Cache-Control: no-cache' -o "${geodata_dir}/geoip.dat" "$download_link_geoip"
curl -H 'Cache-Control: no-cache' -o "${geodata_dir}/geosite.dat" "$download_link_geosite"
# Remove temporary directory
rm -rf "$tmp_dir"
# xray new configuration
install -d /usr/local/etc/xray
envsubst '\$UUID,\$WS_PATH' < $config_path > /usr/local/etc/xray/config.json

# Run xray
/usr/local/bin/xray -config /usr/local/etc/xray/config.json &
# Run nginx
/bin/bash -c "envsubst '\$PORT,\$WS_PATH' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'