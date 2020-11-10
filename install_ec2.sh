#!/bin/bash
  
sudo yum update -y
sudo yum groupinstall 'Development Tools' -y
sudo yum install -y httpd-devel pcre perl pcre-devel zlib zlib-devel geoip geoip-devel openssl openssl-devel gd gd-devel



# Speed up the process
# Env Var NUMJOBS overrides automatic detection
if [[ -n $NUMJOBS ]]; then
    MJOBS=$NUMJOBS
elif [[ -f /proc/cpuinfo ]]; then
    MJOBS=$(grep -c processor /proc/cpuinfo)
elif [[ "$OSTYPE" == "darwin"* ]]; then
        MJOBS=$(sysctl -n machdep.cpu.thread_count)
else
    MJOBS=4
fi



wget http://nginx.org/download/nginx-1.18.0.tar.gz -O /opt/nginx-1.18.0.tar.gz

tar -xvf /opt/nginx-1.18.0.tar.gz -C /opt/

cd /opt/nginx-1.18.0

./configure --prefix=/etc/nginx --sbin-path=/etc/nginx/sbin/nginx --with-cc-opt="-Wno-error" --with-select_modu
le --with-poll_module --with-threads --with-file-aio --with-http_realip_module --with-http_sub_module --with-ht
tp_flv_module --with-http_mp4_module --with-http_image_filter_module --with-http_gunzip_module --with-http_gzip
_static_module --with-http_slice_module --with-http_geoip_module --with-http_v2_module --with-pcre --with-pcre-
jit --with-http_ssl_module --with-threads --with-file-aio

cd /opt/nginx-1.18.0
sudo make -j$MJOBS && sudo make install
sudo rm -rf nginx-1.18.0.tar.gz && sudo rm -rf nginx-1.18.0