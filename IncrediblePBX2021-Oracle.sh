#!/bin/bash

#    Incredible PBX Copyright (C) 2005-2022, Ward Mundy & Associates LLC.
#    This program installs Asterisk, Incredible PBX and GUI on Ubuntu 20.04.
#    All programs copyrighted and licensed by their respective companies.
#
#    Portions Copyright (C) 2005-2022,  Sangoma Technologies, Inc.
#    Portions Copyright (C) 2005-2022,  Ward Mundy & Associates LLC
#    Portions Copyright (C) 2014-2016,  Eric Teeter teetere@charter.net
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#    GPL2 license file can be found at /root/COPYING after installation.
#


clear
#These are the varables required to make the install script work
#Do NOT change them
# original image for 2021.BETA
IMGFILE="RP-2020.12.11.15.02-A16.15.0-F15.0-I2021.Beta1.tar.gz"
version="2021.01U"
ASTVER="18"

exec > >(tee -i /root/incrediblepbx-install-log.txt)
exec 2>&1

COLUMNSIZE=`echo -e "cols"|tput -S`
LINESIZE=`echo -e "lines"|tput -S`

if [[ "$COLUMNSIZE" -lt "82"  ]] || [[ "$LINESIZE" -lt "30"  ]]; then
 echo " "
 echo "****** WARNING WARNING WARNING WARNING ******"
 echo "Window size is too small: $COLUMNSIZE x $LINESIZE"
 echo Resize console window to at least 82 x 30.
 echo "Otherwise, Asterisk may fail to compile."
 echo "****** WARNING WARNING WARNING WARNING ******"
 echo " "
fi

if [ -e "/etc/pbx/.incredible" ]; then
 echo "Incredible PBX is already installed."
 exit 1
fi


clear
echo ".-.                          .-. _ .-.   .-.            .---. .---. .-..-."
echo ": :                          : ::_;: :   : : v $version : .; :: .; :: \`' :"
echo ": :,-.,-. .--. .--.  .--.  .-' :.-.: \`-. : :   .--.     :  _.':   .' \`  ' "
#echo $version
echo ": :: ,. :'  ..': ..'' '_.'' .; :: :' .; :: :_ ' '_.'    : :   : .; :.'  \`."
echo ":_;:_;:_;\`.__.':_;  \`.__.'\`.__.':_;\`.__.'\`.__;\`.__.'    :_;   :___.':_;:_;"
echo "Copyright (c) 2005-2022, Ward Mundy & Associates LLC. All rights reserved."
echo " "
echo "WARNING: This Asterisk $ASTVER install erases ALL existing configurations!"
echo " "
echo "BY USING INCREDIBLE PBX, YOU AGREE TO ASSUME ALL RESPONSIBILITY"
echo "FOR USE OF THE PROGRAMS INCLUDED IN THIS INSTALLATION. NO WARRANTIES"
echo "EXPRESS OR IMPLIED INCLUDING MERCHANTABILITY AND FITNESS FOR PARTICULAR"
echo "USE ARE PROVIDED. YOU ASSUME ALL RISKS KNOWN AND UNKNOWN AND AGREE TO"
echo "HOLD WARD MUNDY, WARD MUNDY & ASSOCIATES LLC, NERD VITTLES, AND THE PBX"
echo "IN A FLASH DEVELOPMENT TEAM HARMLESS FROM ANY AND ALL LOSS OR DAMAGE"
echo "WHICH RESULTS FROM YOUR USE OF THIS SOFTWARE. AS CONFIGURED, THIS"
echo "SOFTWARE CANNOT BE USED TO MAKE 911 CALLS, AND YOU AGREE TO PROVIDE"
echo "AN ALTERNATE PHONE CAPABLE OF MAKING EMERGENCY CALLS. IF ANY OF THESE TERMS"
echo "AND CONDITIONS ARE RULED TO BE UNENFORCEABLE, YOU AGREE TO ACCEPT ONE"
echo "DOLLAR IN U.S. CURRENCY AS COMPENSATORY AND PUNITIVE LIQUIDATED DAMAGES"
echo "FOR ANY AND ALL CLAIMS YOU AND ANY USERS OF THIS SOFTWARE MIGHT HAVE."
echo " "

echo "If you do not agree with these terms and conditions of use, press Ctrl-C now."
read -p "Otherwise, press Enter to proceed at your own risk..."

test=`grep 20.04 /etc/os-release`
if [[ -z $test ]]; then
 proceed=false
 echo " "
 echo "********* WARNING WARNING WARNING WARNING *********"
 echo "Ubuntu 20.04 is the required platform for install."
 echo "********* WARNING WARNING WARNING WARNING *********"
 echo " "
 exit 6
else
 proceed=true
fi


#debian=`cat /etc/debian_version`
#if [[ "$debian" > "10.0" ]]; then
# proceed=true
#else
# proceed=false
#  echo " "
#  echo "********* WARNING WARNING WARNING WARNING *********"
#  echo "Debian 10.7 is the requuired platform at this time."
#  echo "********** WARNING WARNING WARNING WARNING ********"
#  echo " "
#  exit 6
#fi

clear
echo ".-.                          .-. _ .-.   .-.            .---. .---. .-..-."
echo ": :                          : ::_;: :   : : v $version : .; :: .; :: \`' :"
echo ": :,-.,-. .--. .--.  .--.  .-' :.-.: \`-. : :   .--.     :  _.':   .' \`  ' "
#echo $version
echo ": :: ,. :'  ..': ..'' '_.'' .; :: :' .; :: :_ ' '_.'    : :   : .; :.'  \`."
echo ":_;:_;:_;\`.__.':_;  \`.__.'\`.__.':_;\`.__.'\`.__;\`.__.'    :_;   :___.':_;:_;"
echo "Copyright (c) 2005-2022, Ward Mundy & Associates LLC. All rights reserved."
echo " "
echo "Installing Incredible PBX. Please wait. This installer runs unattended"
echo "AFTER you are prompted for your ITU Country Code in approximately 5 minutes."
echo "Consider a modest donation to Nerd Vittles while waiting. Return in 30 minutes."
echo "Do NOT press any keys while the installation is underway. Be patient!"
echo " "
read -p "Read the above. Then press Enter to proceed at your own risk..."

# First is the FreePBX-compatible version number
export VER_FREEPBX=15.0

# Second is the Asterisk Database Password
export ASTERISK_DB_PW=amp109

# Third is the MySQL Admin password. Must be the same as when you install MySQL!!
export ADMIN_PASS=passw0rd

# set the PATH for VM install protection
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
export PATH

DEBIAN_FRONTEND=noninteractive

sed -i 's|rm -i|rm -f|' /root/.bashrc
sed -i 's|cp -i|cp -f|' /root/.bashrc
sed -i 's|mv -i|mv -f|' /root/.bashrc

#echo deb http://ftp.us.debian.org/debian/ buster-backports main > /etc/apt/sources.list.d/backports.list
#echo deb-src http://ftp.us.debian.org/debian/ buster-backports main >> /etc/apt/sources.list.d/backports.list
apt-get update
#apt-get upgrade -y
apt-get install -y build-essential openssh-server apache2 mariadb-server mariadb-client bison flex php \
php-curl php-cli php-mysql php-pear php-gd php-mbstring php-intl php-bcmath curl sox libncurses5-dev \
libssl-dev mpg123 libxml2-dev libnewt-dev sqlite3 libsqlite3-dev pkg-config automake libtool autoconf \
git unixodbc-dev uuid uuid-dev libasound2-dev libogg-dev libvorbis-dev libicu-dev libcurl4-openssl-dev \
libical-dev libneon27-dev libsrtp2-dev libspandsp-dev sudo subversion libtool-bin python2-dev unixodbc \
dirmngr sendmail-bin sendmail debhelper-compat cmake libmariadb-dev php-ldap mailutils dnsutils
# need to find odbc-mariadb replacement
apt-get install -y linux-headers-`uname -r`
# next line is for Ubuntu
apt-get install -y npm
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
apt-get install -y net-tools
apt-get install -y nodejs

pear install Console_Getopt
apt-get install expect -y

echo '#!/usr/bin/expect -f' > /tmp/mysql-setup
echo 'spawn mysql_secure_installation' >> /tmp/mysql-setup
echo 'expect "none"' >> /tmp/mysql-setup
echo 'send "\r"' >> /tmp/mysql-setup
echo 'expect "password?"' >> /tmp/mysql-setup
echo 'sleep 1' >> /tmp/mysql-setup
echo 'send "n\r"' >> /tmp/mysql-setup
echo 'expect "anonymous users?"' >> /tmp/mysql-setup
echo 'sleep 1' >> /tmp/mysql-setup
echo 'send "Y\r"' >> /tmp/mysql-setup
echo 'expect "root login remotely?"' >> /tmp/mysql-setup
echo 'sleep 1' >> /tmp/mysql-setup
echo 'send "Y\r"' >> /tmp/mysql-setup
echo 'expect "test database"' >> /tmp/mysql-setup
echo 'sleep 1' >> /tmp/mysql-setup
echo 'send "Y\r"' >> /tmp/mysql-setup
echo 'expect "Reload privilege tables"' >> /tmp/mysql-setup
echo 'sleep 1' >> /tmp/mysql-setup
echo 'send "Y\r"' >> /tmp/mysql-setup
echo 'expect "Thanks for using"' >> /tmp/mysql-setup
echo 'sleep 1' >> /tmp/mysql-setup
echo 'send "\r\r"' >> /tmp/mysql-setup
chmod +x /tmp/mysql-setup
/tmp/mysql-setup
cd /usr/src
wget http://incrediblepbx.com/dahdi-linux-complete-2.11.1+2.11.1-SGM-20191120.tar.gz
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.6.1.tar.gz
tar zxvf dahdi-linux-complete*.tar.gz
tar zxvf libpri-1.6.1.tar.gz
if [[ "$ASTVER" = "18" ]]; then
# wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz
 wget http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-18.13.0.tar.gz
 tar zxvf asterisk-18*
else
 wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz
 tar zxvf asterisk-16*
fi
mv *.tar.gz /tmp

cd /usr/src
#wget http://pkgs.fedoraproject.org/repo/pkgs/iksemel/iksemel-1.4.tar.gz/532e77181694f87ad5eb59435d11c1ca/iksemel-1.4.tar.gz
wget http://incrediblepbx.com/iksemel-1.4.tar.gz
tar zxvf iksemel-1.4.tar.gz
cd iksemel-1.4
./configure --prefix=/usr --with-libgnutls-prefix=/usr
make
make check
make install
echo "/usr/local/lib" > /etc/ld.so.conf.d/iksemel.conf
ldconfig

mv *.tar.gz /tmp

#add dahdi and libpri compiles and revise menuselect to incorporate


if [[ "$ASTVER" = "18" ]]; then
 cd /usr/src/asterisk-18*
else
 cd /usr/src/asterisk-16*
fi

echo '#!/usr/bin/expect -f' > prereq-setup
echo 'set timeout 600' >> prereq-setup
echo 'spawn contrib/scripts/install_prereq "install"' >> prereq-setup
echo 'expect "ITU-T telephone code"' >> prereq-setup
echo 'sleep 1' >> prereq-setup
echo 'send "\t"' >> prereq-setup
echo 'sleep 1' >> prereq-setup
echo 'send "\r"' >> prereq-setup
echo 'sleep 1' >> prereq-setup
echo 'send "\r\r"' >> prereq-setup
chmod +x prereq-setup
./prereq-setup
tput setab 7
tput setaf 4
tput sgr0
clear

### added expect code to trap telcode =1 
#contrib/scripts/install_prereq install

contrib/scripts/get_mp3_source.sh

# install on server
if [[ "$ASTVER" = "18" ]]; then
 wget http://incrediblepbx.com/menuselect-incredible18-debian10.tar.gz
else
 wget http://incrediblepbx.com/menuselect-incredible16-debian10.tar.gz
fi
tar zxvf menuselect-incredible*
rm -f menuselect-incredible*
CFLAGS='-DENABLE_SRTP_AES_256 -DENABLE_SRTP_AES_GCM' ./configure  --libdir=/usr/lib64 --with-pjproject-bundled --with-jansson-bundled

make menuselect.makeopts
if [[ "$ASTVER" = "18" ]]; then
 menuselect/menuselect --enable-category MENUSELECT_ADDONS menuselect.makeopts
 menuselect/menuselect --enable-category MENUSELECT_CODECS menuselect.makeopts
 menuselect/menuselect --disable-category MENUSELECT_TESTS menuselect.makeopts
 menuselect/menuselect --enable CORE-SOUNDS-EN-GSM --enable MOH-OPSOUND-WAV --enable EXTRA-SOUNDS-EN-GSM --enable cdr_mysql menuselect.makeopts
 menuselect/menuselect --disable test_named_lock --disable test_res_pjsip_scheduler --disable test_file --disable test_bridging --disable test_res_pjsip_scheduler menuselect.makeopts
 menuselect/menuselect --disable test_res_rtp --disable app_voicemail_odbc --disable app_voicemail_imap menuselect.makeopts
 menuselect/menuselect --enable app_macro menuselect.makeopts
 menuselect/menuselect --disable codec_opus menuselect.makeopts
 menuselect/menuselect --disable codec_silk menuselect.makeopts
 menuselect/menuselect --disable codec_siren7 menuselect.makeopts
 menuselect/menuselect --disable codec_siren14 menuselect.makeopts
 menuselect/menuselect --disable codec_g729a menuselect.makeopts
 menuselect/menuselect --disable test_aeap menuselect.makeopts
 menuselect/menuselect --disable test_aeap_speech menuselect.makeopts
 menuselect/menuselect --disable test_aeap_transaction menuselect.makeopts
 menuselect/menuselect --disable test_aeap_transport menuselect.makeopts
 menuselect/menuselect --disable test_mwi --disable test_res_pjsip_session_caps --disable test_stasis_state --disable test_res_prometheus menuselect.makeopts
else
 menuselect/menuselect --enable-category MENUSELECT_ADDONS menuselect.makeopts
 menuselect/menuselect --enable-category MENUSELECT_CODECS menuselect.makeopts
 menuselect/menuselect --disable-category MENUSELECT_TESTS menuselect.makeopts
 menuselect/menuselect --enable CORE-SOUNDS-EN-GSM --enable MOH-OPSOUND-WAV --enable EXTRA-SOUNDS-EN-GSM --enable cdr_mysql menuselect.makeopts
 menuselect/menuselect --disable codec_opus menuselect.makeopts
 menuselect/menuselect --disable codec_silk menuselect.makeopts
 menuselect/menuselect --disable codec_siren7 menuselect.makeopts
 menuselect/menuselect --disable codec_siren14 menuselect.makeopts
 menuselect/menuselect --disable codec_g729a menuselect.makeopts
 menuselect/menuselect --disable test_named_lock --disable test_res_pjsip_scheduler --disable test_file --disable test_bridging --disable test_res_pjsip_scheduler menuselect.makeopts
 menuselect/menuselect --disable test_res_rtp menuselect.makeopts
 menuselect/menuselect --disable test_aeap menuselect.makeopts
 menuselect/menuselect --disable test_aeap_speech menuselect.makeopts
 menuselect/menuselect --disable test_aeap_transaction menuselect.makeopts
 menuselect/menuselect --disable test_aeap_transport menuselect.makeopts
 menuselect/menuselect --enable app_macro menuselect.makeopts
fi
make menuselect.makeopts
### turn off Build Native
#make menuselect
make
make install
make config
make samples
ldconfig
touch /etc/asterisk/stir_shaken.conf

groupadd asterisk
useradd -r -d /var/lib/asterisk -g asterisk asterisk
usermod -aG audio,dialout asterisk
chown -R asterisk.asterisk /etc/asterisk
chown -R asterisk.asterisk /var/{lib,log,spool}/asterisk
#chown -R asterisk.asterisk /usr/lib/asterisk

sed -i 's|#AST_USER|AST_USER|' /etc/default/asterisk
sed -i 's|#AST_GROUP|AST_GROUP|' /etc/default/asterisk
sed -i 's|;runuser|runuser|' /etc/asterisk/asterisk.conf
sed -i 's|;rungroup|rungroup|' /etc/asterisk/asterisk.conf

echo "/usr/lib64" >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf
ldconfig

sed -i 's";\[radius\]"\[radius\]"g' /etc/asterisk/cdr.conf
sed -i 's";radiuscfg => /usr/local/etc/radiusclient-ng/radiusclient.conf"radiuscfg => /etc/radcli/radiusclient.conf"g' /etc/asterisk/cdr.conf
sed -i 's";radiuscfg => /usr/local/etc/radiusclient-ng/radiusclient.conf"radiuscfg => /etc/radcli/radiusclient.conf"g' /etc/asterisk/cel.conf

systemctl restart asterisk

mkdir /etc/pbx


#Ready for FreePBX 15 base install
systemctl stop asterisk
systemctl disable asterisk
killall asterisk
cd /etc/asterisk
mkdir DIST
mv * DIST
cp DIST/asterisk.conf .
sed -i 's/(!)//' asterisk.conf
touch modules.conf
touch cdr.conf

sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php/7.4/apache2/php.ini
sed -i 's/\(^memory_limit = \).*/\1256M/' /etc/php/7.4/apache2/php.ini
sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/apache2/apache2.conf
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

a2enmod rewrite
systemctl restart apache2
rm /var/www/html/index.html

cat <<EOF > /etc/odbcinst.ini
[MySQL]
Description = ODBC for MySQL (MariaDB)
Driver = /usr/lib/x86_64-linux-gnu/odbc/libmaodbc.so
FileUsage = 1
EOF

cat <<EOF > /etc/odbc.ini
[MySQL-asteriskcdrdb]
Description = MySQL connection to 'asteriskcdrdb' database
Driver = MySQL
Server = localhost
Database = asteriskcdrdb
Port = 3306
Socket = /var/run/mysqld/mysqld.sock
Option = 3
EOF

cd /usr/src
# wget "https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"
wget "http://incrediblepbx.com/ffmpeg-release-amd64-static.tar.xz"
tar xf ffmpeg-release-amd64-static.tar.xz
cd ffmpeg-4*
mv ffmpeg /usr/local/bin

cd /usr/src
wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-15.0-latest.tgz
tar zxvf freepbx-15.0-latest.tgz
cd /usr/src/freepbx/
./start_asterisk start
./install -n

mysqladmin -u root password 'passw0rd'

cd /
wget http://incrediblepbx.com/rootfiles-debian10.tar.gz
tar zxvf rootfiles-debian10.tar.gz
chattr +i /root/up*
chattr +i /usr/local/sbin/pbxstatus

echo "Ready for Incredible PBX 2021 default snapshot..."
### LOAD 2021 SNAPSHOT HERE
cd /backup
wget http://incrediblepbx.com/$IMGFILE
cd /root
sed -i 's|PROCEEDNOW=false|PROCEEDNOW=true|' /root/incrediblerestore2021
./incrediblerestore2021 /backup/$IMGFILE
sed -i 's|PROCEEDNOW=true|PROCEEDNOW=false|' /root/incrediblerestore2021

cd /
tar zxvf rootfiles-debian10.tar.gz
rm -f rootfiles-debian10.tar.gz

cd /root
rm -f status7

apt-get install sox lame ffmpeg -y

cat <<EOF > /etc/systemd/system/incrediblepbx.service
[Unit]
Description=Incredible PBX 2021
After=mariadb.service
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/fwconsole start -q
ExecStop=/usr/sbin/fwconsole stop -q
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable incrediblepbx

### load image backup here and restart Asterisk
fwconsole restart
fwconsole reload

apt-get install knockd -y
sed -i 's|START_KNOCKD=0|START_KNOCKD=1|' /etc/default/knockd
test=`ifconfig | grep eth0`
if [ -z "$test" ]; then
 test2=`ifconfig | grep wlan0`
 if [ -z "$test2" ]; then
  devport=`ifconfig | head -n 1 | cut -f 1 -d ":"`
  echo "KNOCKD_OPTS=\"-i $devport\"" >> /etc/default/knockd
 else
  echo 'KNOCKD_OPTS="-i wlan0"' >> /etc/default/knockd
 fi
fi

echo "[options]" > /etc/knockd.conf
echo "       logfile = /var/log/knockd.log" >> /etc/knockd.conf
echo "" >> /etc/knockd.conf
echo "[opencloseALL]" >> /etc/knockd.conf
echo "        sequence      = 7:udp,8:udp,9:udp" >> /etc/knockd.conf
echo "        seq_timeout   = 15" >> /etc/knockd.conf
echo "        tcpflags      = syn" >> /etc/knockd.conf
echo "        start_command = /usr/sbin/iptables -I INPUT -s %IP% -j ACCEPT" >> /etc/knockd.conf
echo "        cmd_timeout   = 3600" >> /etc/knockd.conf
echo "        stop_command  = /usr/sbin/iptables -D INPUT -s %IP% -j ACCEPT" >> /etc/knockd.conf
chmod 640 /etc/knockd.conf
# randomize ports here
lowest=6001
highest=9950
knock1=$[ ( $RANDOM % ( $[ $highest - $lowest ] + 1 ) ) + $lowest ]
knock2=$[ ( $RANDOM % ( $[ $highest - $lowest ] + 1 ) ) + $lowest ]
knock3=$[ ( $RANDOM % ( $[ $highest - $lowest ] + 1 ) ) + $lowest ]
sed -i 's|7:udp|'$knock1':tcp|' /etc/knockd.conf
sed -i 's|8:udp|'$knock2':tcp|' /etc/knockd.conf
sed -i 's|9:udp|'$knock3':tcp|' /etc/knockd.conf
systemctl restart knockd
systemctl enable knockd
echo " "
echo "Knock ports for access to $publicip set to TCP: $knock1 $knock2 $knock3" > /root/knock.FAQ
echo "UPnP activation attempted for UDP 5060 and your knock ports above." >> /root/knock.FAQ
echo "To enable knockd on your server, issue the following commands:" >> /root/knock.FAQ
echo "  chkconfig --level 2345 knockd on" >> /root/knock.FAQ
echo "  service knockd start" >> /root/knock.FAQ
echo "To enable remote access, issue these commands after yum -y install nmap:" >> /root/knock.FAQ
echo "nmap -p $knock1 --max-retries 0 $publicip && nmap -p $knock2 --max-retries 0 $publicip && nmap -p $knock3 --max-retries 0 $publicip" >> /root/knock.FAQ
echo "Or install iOS PortKnock or Android DroidKnocker on remote device." >> /root/knock.FAQ


cat <<EOF > /etc/systemd/system/rclocal.service
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
After=incrediblepbx.service
[Service]
Type=forking
ExecStart=/etc/rc.local
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
PermissionsStartOnly=true
SysVStartPriority=99
 [Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable rclocal

echo "#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will 'exit zero' on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

service knockd start
sleep 5
/usr/local/sbin/iptables-restart
#fwconsole start ucp
exit 0
" > /etc/rc.local
chmod +x /etc/rc.local

# Installing WebMin
echo "Installing WebMin..."
echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
cd /root
wget -qO- http://www.webmin.com/jcameron-key.asc | sudo apt-key add
apt-get update
apt-get install webmin -y
sed -i 's|10000|9001|g' /etc/webmin/miniserv.conf
service webmin restart

# Installing NeoRouter
#wget http://download.neorouter.com/Downloads/NRFree/Update_2.3.1.4360/Linux/Ubuntu/nrclient-2.3.1.4360-free-ubuntu-amd64.deb
#dpkg -i nrclient-2.3.1.4360-free-ubuntu-amd64.deb

systemctl start rclocal

# add PicoTTS support
cd /root
wget http://incrediblepbx.com/picotts-debian10.tar.gz
tar zxvf picotts-debian10.tar.gz
dpkg -i libttspico*
# pico2wave is the stand-alone pico utility

echo "Resetting default passwords..."
lowest=765432567873
highest=9999999999999
val1=a$[ ( $RANDOM % ( $[ $highest - $lowest ] + 1 ) ) ]d
val2=c$[ ( $RANDOM % ( $[ $highest - $lowest ] + 1 ) ) ]f
val3=b$[ ( $RANDOM % ( $[ $highest - $lowest ] + 1 ) ) ]e
val4=$[ ( $RANDOM % ( $[ $highest - $lowest ] + 1 ) ) ]
val5=$[ ( $RANDOM % ( $[ $highest - $lowest ] + 1 ) ) ]
pw701=$val2$val5$val4$val3$val1
pw702=$val4$val2$val1$val5$val3
pw703=$val3$val4$val2$val1$val5
pw704=$val1$val3$val5$val4$val2
pw705=$val5$val1$val3$val2$val4
mysql -u root -ppassw0rd asterisk -e "UPDATE sip SET data = '$pw701' where ID = 701 and keyword = 'secret' limit 1;"
mysql -u root -ppassw0rd asterisk -e "UPDATE sip SET data = '$pw702' where ID = 702 and keyword = 'secret' limit 1;"
mysql -u root -ppassw0rd asterisk -e "UPDATE sip SET data = '$pw703' where ID = 703 and keyword = 'secret' limit 1;"
mysql -u root -ppassw0rd asterisk -e "UPDATE sip SET data = '$pw704' where ID = 704 and keyword = 'secret' limit 1;"
mysql -u root -ppassw0rd asterisk -e "UPDATE sip SET data = '$pw705' where ID = 705 and keyword = 'secret' limit 1;"
mysql -u root -ppassw0rd asterisk -e "update freepbx_settings SET value = '16.0' where keyword='FORCED_ASTVERSION';"
mysql -u root -ppassw0rd asterisk -e "update admin SET value = 'true' where variable='need_reload';"

lowest=1234
highest=9999
userpin=$[ ( $RANDOM % ( $[ $highest ] + 1 ) ) ]
adminpin=$[ ( $RANDOM % ( $[ $highest ] + 1 ) ) ]
asterisk -rx "database put CONFERENCE 2663/userpin $userpin"
asterisk -rx "database put CONFERENCE 2663/adminpin $adminpin"

lowest=12345677
highest=99999888
userpin=$[ ( $RANDOM % ( $[ $highest ] + 1 ) ) ]
currline=`grep -n 'Authenticate' /etc/asterisk/extensions_custom.conf | cut -f 2 -d ":" | cut -f 2 -d "("`
newline="$userpin)"
sed -i 's|'$currline'|'$newline'|' /etc/asterisk/extensions_custom.conf

fwconsole reload

sed -i 's|#PermitRootLogin prohibit-password|PermitRootLogin yes|' /etc/ssh/sshd_config
systemctl restart sshd

# PHP 5.6/7.3 Dual Boot Setup with 5.6 as default to support Incredible Fax and AvantFax
apt-get install software-properties-common -y
#wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
#echo "deb https://packages.sury.org/php/ buster main" | sudo tee /etc/apt/sources.list.d/php.list
add-apt-repository -y ppa:ondrej/php
apt-get update
apt-get install php5.6 -y
apt-get install php5.6-bcmath php5.6-curl php5.6-gd php5.6-intl php5.6-ldap php5.6-mbstring php5.6-mysql php5.6-xml -y
sed -i 's|128M|256M|' /etc/php/5.6/apache2/php.ini
sed -i 's|128M|256M|' /etc/php/5.6/cli/php.ini
#a2dismod php7.3
a2dismod php7.4
a2enmod php5.6
update-alternatives --set php /usr/bin/php5.6
sed -i 's|;max_input_vars = 1000|max_input_vars = 5000|' /etc/php/7.4/cli/php.ini
sed -i 's|;max_input_vars = 1000|max_input_vars = 5000|' /etc/php/5.6/cli/php.ini
sed -i 's|;max_input_vars = 1000|max_input_vars = 5000|' /etc/php/7.4/apache2/php.ini
sed -i 's|;max_input_vars = 1000|max_input_vars = 5000|' /etc/php/5.6/apache2/php.ini
systemctl restart apache2

#IPtables Setup
cd /root
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
apt-get install -y iptables-persistent dialog
cd /etc/init.d
wget http://incrediblepbx.com/iptables-persistent-U.tar.gz
tar zxvf iptables-persistent-U.tar.gz
rm iptables-persistent-U.tar.gz

# server IP address is?
serverip=`ifconfig | grep "inet " | head -1 | cut -f 2 -d ":" | tr -s " " | cut -f 3 -d " "`
# user IP address while logged into SSH is?
userip=`echo $SSH_CONNECTION | cut -f 1 -d " "`
# public IP address in case we're on private LAN
publicip=`curl https://ipinfo.io/ip`
# WhiteList all of them by replacing 8.8.4.4 and 8.8.8.8 and 74.86.213.25 entries
cp /etc/iptables/rules.v4 /etc/iptables/rules.v4.orig
cd /etc/iptables
cp /etc/iptables/rules.v4 /etc/iptables/rules.v4.orig
wget http://incrediblepbx.com/iptables4-ubuntu18.04.2.tar.gz
tar zxvf iptables4-ubuntu18.04.2.tar.gz
rm iptables4-ubuntu18.04.2.tar.gz
mv iptables-custom /usr/local/sbin
mv pbxstatus /usr/local/sbin
mv openssl.cnf /etc/ssl
cp rules.v4.tm3 rules.v4
sed -i 's|8.8.4.4|'$serverip'|' /etc/iptables/rules.v4
sed -i 's|8.8.8.8|'$userip'|' /etc/iptables/rules.v4
sed -i 's|74.86.213.25|'$publicip'|' /etc/iptables/rules.v4
badline=`grep -n "\-s  \-p" /etc/iptables/rules.v4 | cut -f1 -d: | tail -1`
while [[ "$badline" != "" ]]; do
sed -i "${badline}d" /etc/iptables/rules.v4
badline=`grep -n "\-s  \-p" /etc/iptables/rules.v4 | cut -f1 -d: | tail -1`
done
sed -i 's|-A INPUT -s  -j|#-A INPUT -s  -j|g' /etc/iptables/rules.v4
#sed -i 's|#-A INPUT -p tcp -m tcp --dport 22|-A INPUT -p tcp -m tcp --dport 22|' rules.v4
ln -s /etc/init.d/iptables-persistent /etc/init.d/iptables

/etc/init.d/iptables restart
/usr/local/sbin/iptables-custom

sed -i 's|instance|noreply.incrediblepbx.com instance|' /etc/hosts
sed -i 's|PasswordAuthentication no|PasswordAuthentication yes|' /etc/ssh/sshd_config
systemctl restart ssh

apt-get install fail2ban -y
#cd /etc/fail2ban/jail.d
#echo " " >> defaults-debian.conf
#echo "[asterisk]" >> defaults-debian.conf
#echo "enabled = true" >> defaults-debian.conf

# kill all the endless Fail2Ban alerts
echo "devnull:        /dev/null" >> /etc/aliases
newaliases
sed -i 's|you@example.com|devnull@localhost|' /etc/fail2ban/jail.conf
systemctl restart fail2ban
rm -f /var/spool/mqueue/*

# install OpenVPN
apt-get install openvpn -y

# remove CentOS fax installer
rm -f /root/incrediblefax2020.sh

# CentOS-like color scheme for ls
echo "export LS_OPTIONS='--color=auto'
eval \"\`dircolors\`\"
alias ls='ls \$LS_OPTIONS'
alias ll='ls -l \$LS_OPTIONS'" >> /etc/bash.bashrc

# Checking for IPv6
test=`ifconfig | grep inet6`
if [ -z "$test" ]; then
 echo "IPv6 not enabled."
else
 echo "Disabling IPv6..."
 echo "net.ipv6.conf.all.disable_ipv6 = 1" > /etc/sysctl.d/70-disable-ipv6.conf
 sysctl -p -f /etc/sysctl.d/70-disable-ipv6.conf
 echo "IPv6 has been disabled."
fi

echo "$version" > /etc/pbx/.version

if [ -e "/usr/sbin/fwconsole" ]; then
 echo " "
else
 ln -s /var/lib/asterisk/bin/fwconsole /usr/sbin/fwconsole
fi

if [[ "$ASTVER" = "18" ]]; then
 rm -f /root/upgrade-asterisk16
fi

apt-get install ntp -y
systemctl enable ntp

# Ubuntu patches
cp -p /root/pbxstatus-U /usr/local/sbin/pbxstatus
rm -rf /tmp/*
cd /root
mv switch-to-php7.3 switch-to-php7.4
sed -i 's|7.3|7.4|' switch-to-php5.6
sed -i 's|7.3|7.4|' switch-to-php7.4

systemctl restart mysqld
fwconsole restart
fwconsole ma install userman
fwconsole ma upgradeall
fwconsole reload
/root/sig-fix
/root/sig-fix

echo '[Unit]
Description=openvpn2021
ConditionPathExists=/etc/openvpn-start
After=rclocal.service
[Service]
Type=forking
ExecStart=/etc/openvpn-start /etc/incrediblepbx2021.ovpn
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
PermissionsStartOnly=true
SysVStartPriority=99
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/openvpn2021.service
chmod +x /etc/systemd/system/openvpn2021.service
cp -p /root/openvpn-start /etc/openvpn-start
systemctl enable openvpn2021.service

# Watson STT fix
sed -i 's|/usr/local/sbin/we-dont-have-tech-support.wav|/var/lib/asterisk/sounds/en/we-dont-have-tech-support.gsm|' /usr/local/sbin/watson-test
clear

# late breaking fixes
touch /etc/asterisk/stir_shaken.conf
sed -i 's|noload = res_phoneprov.so|load = res_phoneprov.so|' /etc/asterisk/modules.conf
sed -i 's|noload = cdr_mysql.so|load = cdr_mysql.so|' /etc/asterisk/modules.conf
echo "websocket_enabled = no" >> /etc/asterisk/sip_custom.conf
chown asterisk:asterisk /etc/asterisk/*
rm -f /root/incrediblefax2020-debian10.sh

# Missing CDR bug fix
apt-get update
apt-get install odbc-mariadb -y

cd /usr/local/sbin
wget http://incrediblepbx.com/pbxstatus-oracle.tar.gz
tar zxvf pbxstatus-oracle.tar.gz
rm -f pbxstatus-oracle.tar.gz

fwconsole restart
rm -f /tmp/*
fwconsole ma downloadinstall http://pbxossa.org/files/outcnam/outcnam-latest.tgz
fwconsole ma downloadinstall sipsettings
fwconsole restart
fwconsole ma upgradeall
fwconsole ma disable clearlytrunking
fwconsole ma disable clearlydevices
#fwconsole ma disable fax
fwconsole reload
fwconsole setting NODEJSENABLED 0
/root/create-swapfile-DO
/root/update-IncrediblePBX
/root/sig-fix
/root/sig-fix
sed -i 's|;max_input_vars = 1000|max_input_vars = 5000|' /etc/php/7.4/cli/php.ini
sed -i 's|;max_input_vars = 1000|max_input_vars = 5000|' /etc/php/5.6/cli/php.ini
sed -i 's|;max_input_vars = 1000|max_input_vars = 5000|' /etc/php/7.4/apache2/php.ini
sed -i 's|;max_input_vars = 1000|max_input_vars = 5000|' /etc/php/5.6/apache2/php.ini
systemctl restart apache2

cd /var/lib/asterisk/agi-bin
apt-get -y install pip
apt-get -y install jq
apt-get -y install libsox-fmt-all
pip install gTTS
wget http://incrediblepbx.com/gtts.tar.gz
tar zxvf gtts.tar.gz
rm -f gtts.tar.gz
./install-gtts-dialplan.sh
cd /root

# ODBC CDR/CEL fix from Bill Simon
apt-get -y install libmariadb3
wget http://incrediblepbx.com/odbc-mariadb_3.1.9-1_arm64.deb.tgz
tar zxvf odbc-mariadb_3.1.9-1_arm64.deb.tgz
dpkg -i odbc-mariadb_3.1.9-1_arm64.deb

echo "[MariaDB Unicode]
Driver=libmaodbc.so
Description=MariaDB Connector/ODBC(Unicode)
Threading=0
UsageCount=1

[MySQL]
Description=ODBC for MySQL (MariaDB)
Driver=/usr/lib/aarch64-linux-gnu/odbc/libmaodbc.so
Setup = /usr/lib/aarch64-linux-gnu/odbc/libodbcmyS.so
FileUsage=1
" > /etc/odbcinst.ini

echo "[MySQL-asteriskcdrdb]
Description = MySQL connection to 'asteriskcdrdb' database
Driver = MySQL
Server = localhost
Database = asteriskcdrdb
Port = 3306
Socket = /run/mysqld/mysqld.sock
Option = 3

[MySQL-asterisk]
Description = MySQL Asterisk
Driver = MySQL
Database = asterisk
Server = localhost
Port = 3306
Socket = /run/mysqld/mysqld.sock
Option = 3

[MySQL-timeclock]
Description = MySQL Timeclock
Driver = MySQL
Database = timeclock
Server = localhost
Port = 3306
Socket = /run/mysqld/mysqld.sock
Option = 3

[MySQL-asteridex]
Description = MySQL AsteriDex
Driver = MySQL
Database = asteridex
Server = localhost
Port = 3306
Socket = /run/mysqld/mysqld.sock
Option = 3
" > /etc/odbc.ini

fwconsole restart
rm -f /tmp/*
fwconsole reload
sed -i 's|7.3|7.4|' /root/timezone-setup

cd /root
wget http://incrediblepbx.com/incrediblefax2021-ubuntu20.04.sh
chmod +x incrediblefax2021-ubuntu20.04.sh
sed -i 's|/usr/local/sbin/gui-fix|/root/sig-fix|' incrediblefax2021-ubuntu20.04.sh

read -p "Press Enter to reboot or Ctrl-C to exit..."
/usr/local/sbin/reboot
