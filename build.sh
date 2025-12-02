VERSION=$1
BUILD_DIRECTORY=$2/Pack/src
DOVECOT_DIRECTORY=$3

#Пакеты компилятора и зависимости
sudo apt-get update -y && sudo apt-get install -y apt-utils && sudo apt-get install -y gettext-base gettext openssh-client ca-certificates pkg-config wget git coreutils ed

sudo apt-get install -y \
  build-essential make autoconf automake libtool bison flex autotools-dev \
  libssl-dev libldap2-dev libbz2-dev zlib1g-dev liblz4-dev libzstd-dev libcap-dev libsodium-dev libunwind-dev libwrap0-dev libkrb5-dev libpq-dev libsqlite3-dev libexpat1-dev \
  liblua5.3-dev libxapian-dev libstemmer-dev libsasl2-dev libicu-dev krb5-multidev libdb-dev libcurl4-gnutls-dev libexpat-dev libexttextcat-dev default-libmysqlclient-dev \
  libpcre3-dev libcdb-dev liblzma-dev liblmdb-dev libunbound-dev libmagic-dev

#cd $2/Pack/Temp && unzip src_dovecot_*.zip && unzip r7mdaserver_*.zip -d $BUILD_DIRECTORY && cd $2

#Переменная окружения:
CFLAGS="$CFLAGS -ffile-prefix-map=$PWD=." LDFLAGS="$LDFLAGS" CXXFLAGS="$CFLAGS -ffile-prefix-map=$PWD=. "

# Создание директории назначения
sudo mkdir -p $BUILD_DIRECTORY

#Чистка предыдущей установки, если такая была
sudo make distclean || true

#Сборка Ядра:

## Automake
sudo ./autogen.sh $VERSION

## Конфигурирование пакетов
sudo ./configure --with-dovecot=$DOVECOT_DIRECTORY \
--with-managesieve=yes \
--prefix=$DOVECOT_DIRECTORY/Pack/src/opt/r7mdaserver \
--exec-prefix=$DOVECOT_DIRECTORY/Pack/src/opt/r7mdaserver

##Компоновка
sudo make -j V=0

## Сборка
sudo make install-strip


# Добавление необходимых пользователей
#  useradd --system dovecot
#  useradd --system dovenull
#  useradd --system vmail
#sudo mkdir -p "$BUILD_DIRECTORY/ssl"
#sudo openssl genrsa -out "$BUILD_DIRECTORY/ssl/private.key" 2048
#sudo openssl req -new -x509 -key "$BUILD_DIRECTORY/ssl/private.key" -out "$BUILD_DIRECTORY/ssl/certificate.crt" -days 365 -subj "/C=RU/ST=Moscow/L=Moscow/O=Company/CN=localhost"
#sudo chmod 600 "$BUILD_DIRECTORY/ssl/private.key"
#sudo chmod 644 "$BUILD_DIRECTORY/ssl/certificate.crt"
#sudo sed -i "s|cert_file = /etc/ssl/dovecot-build-cert.pem|cert_file = $BUILD_DIRECTORY/ssl/certificate.crt|" $BUILD_DIRECTORY/etc/dovecot/dovecot.conf
#sudo sed -i "s|key_file = /etc/ssl/dovecot-build-key.pem|key_file = $BUILD_DIRECTORY/ssl/private.key|" $BUILD_DIRECTORY/etc/dovecot/dovecot.conf

# Запуск демона
#echo "Запустить собранный dovecot? (Y/n) [n]: "
#read -t 5 -n 1 -r response
#if [[ $response =~ ^[Yy]$ ]]; then
#  $BUILD_DIRECTORY/sbin/dovecot -c $BUILD_DIRECTORY/etc/dovecot/dovecot.conf -F
#fi