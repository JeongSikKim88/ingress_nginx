#!/bin/bash

# os check
os=$(cat /etc/issue | awk '{print $1}')

# update & install dependency library
if [ $os == "Ubuntu" ];
then
    apt-get update && apt-get install -y build-essential
    apt get install -y libpcre3 libpcre3-dev php-gd libssl-dev openssl libgd-dev libgeoip-dev zlib1g-dev libxslt-dev
    # echo "another"
else
    yum update -y
    yum groupinstall 'Development Tools' -y
    yum install -y httpd-devel pcre perl pcre-devel zlib zlib-devel geoip geoip-devel
    # echo "cent"    
fi



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

tar -xvf /opt/nginx-1.18.0.tar.gz

cd /opt/nginx-1.18.0

./configure --prefix=/etc/nginx --sbin-path=/etc/nginx/sbin/nginx --with-cc-opt="-Wno-error" --with-select_module --with-poll_module --with-threads --with-file-aio --with-http_realip_module --with-http_sub_module --with-http_flv_module --with-http_mp4_module --with-http_image_filter_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_slice_module --with-http_geoip_module --with-http_v2_module --with-pcre --with-pcre-jit --with-http_ssl_module --with-threads --with-file-ai

cd /opt/nginx-1.18.0
make -j$MJOBS && make install