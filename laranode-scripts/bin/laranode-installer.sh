
#!/bin/bash

# Hiển thị logo Laranode
echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Cloning Laranode"
git clone https://github.com/thanhan92-f1/cloudlab-panel.git /home/laranode_ln/panel
if [ ! -f /home/laranode_ln/panel/artisan ]; then
    echo "Clone failed hoặc thiếu file artisan! Kiểm tra lại repo hoặc kết nối mạng."
    exit 1
fi
echo "--------------------------------------------------------------------------------"
echo '    | $$      | $$     | $$  | $$| $$  | $$| $$  | $$| $$      | $$    $$| $$    $$      | $$    $$| $$    $$| $$$$\ $$| $$  \   | $$      '
echo '    | $$   __ | $$     | $$  | $$| $$  | $$| $$  | $$| $$      | $$$$$$$$| $$$$$$$\      | $$$$$$$ | $$$$$$$$| $$\$$ $$| $$$$$   | $$      '
echo '    | $$__/  \| $$_____| $$__/ $$| $$__/ $$| $$__/ $$| $$_____ | $$  | $$| $$__/ $$      | $$      | $$  | $$| $$ \$$$$| $$_____ | $$_____ '
echo '     \$$    $$| $$     \\$$    $$ \$$    $$| $$    $$| $$     \| $$  | $$| $$    $$      | $$      | $$  | $$| $$  \$$$| $$     \| $$     \'
echo '      \$$$$$$  \$$$$$$$$ \$$$$$$   \$$$$$$  \$$$$$$$  \$$$$$$$$ \$$   \$$ \$$$$$$$        \$$       \$$   \$$ \$$   \$$ \$$$$$$$$ \$$$$$$$$'
echo '                                                                                                                                            '
echo '                                                                                                                                            '
echo -e "\033[0m"

# Exit on any error
# set -e

export DEBIAN_FRONTEND=noninteractive

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Installing software-properties-common and git"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

apt update
apt install -y software-properties-common git

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Installing Apache Web Server"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

apt install -y apache2


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Installing Sysstat"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

apt-get install -y sysstat
sed -i 's/ENABLED="false"/ENABLED="true"/' /etc/default/sysstat
systemctl restart sysstat
systemctl enable sysstat


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Enabling and starting apache2"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

systemctl enable apache2
systemctl start apache2

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Installing MySQL Server"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

apt install -y mysql-server
systemctl enable mysql
systemctl start mysql


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Creating Laranode MySQL User & Database"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

LARANODE_RANDOM_PASS=$(openssl rand -base64 12)
ROOT_RANDOM_PASS=$(openssl rand -base64 12)

mysql -u root -e "CREATE USER 'laranode'@'localhost' IDENTIFIED BY '$LARANODE_RANDOM_PASS';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'laranode'@'localhost' WITH GRANT OPTION;"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u root -e "CREATE DATABASE laranode;"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$ROOT_RANDOM_PASS';"

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Adding ppa:ondrej/php"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
add-apt-repository -y ppa:ondrej/php

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Running apt update"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
apt update

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Installing php8.4 and required extensions"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
apt install -y php8.4 php8.4-fpm php8.4-cli php8.4-common php8.4-curl php8.4-mbstring \
               php8.4-xml php8.4-bcmath php8.4-zip php8.4-mysql php8.4-sqlite3 php8.4-pgsql \
               php8.4-gd php8.4-imagick php8.4-intl php8.4-readline php8.4-tokenizer php8.4-fileinfo \
               php8.4-soap php8.4-opcache unzip curl


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Enabling and starting PHP-FPM"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

systemctl enable php8.4-fpm
systemctl start php8.4-fpm

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Enabling proxy_fcgi apache module"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
a2enmod proxy_fcgi

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Enabling rewrite_module apache module"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
a2enmod rewrite

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Enabling setenvif apache module"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
a2enmod setenvif


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Enabling headers apache module"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
a2enmod headers

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Enabling ssl apache module"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
a2enmod ssl

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Installing certbot"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
apt -y install certbot python3-certbot-apache


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Enabling php8.4-fpm apache configuration"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
a2enconf php8.4-fpm

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Restarting apache2"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

systemctl restart apache2

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Adding www-data to sudoers and allowing to run laranode scripts"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

echo "www-data ALL=(ALL) NOPASSWD: /home/laranode_ln/panel/laranode-scripts/bin/*.sh, /usr/sbin/a2dissite, /bin/rm /etc/apache2/sites-available/*.conf" >> /etc/sudoers

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Installing Composer"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Installing NodeJS"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Creating Laranode User"
useradd -m -s /bin/bash laranode_ln
usermod -aG laranode_ln www-data
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Cloning Laranode"
echo -e "\033[0m"

git clone https://gitlab.hitechcloud.dev/hitechcloud/cloud-lab-panel.git /home/laranode_ln/panel
echo "--------------------------------------------------------------------------------"


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Installing Laranode"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"


cd /home/laranode_ln/panel
# Tự động hóa Composer khi chạy bằng root
if [ "$(id -u)" -eq 0 ]; then
    export COMPOSER_ALLOW_SUPERUSER=1
    composer install --no-interaction
else
    composer install
fi

# Đổi tên .env.example thành .env nếu .env chưa tồn tại
if [ ! -f .env ]; then
    cp .env.example .env
    echo "Đã tạo file .env từ .env.example."
else
    echo "Đã tồn tại file .env, không ghi đè."
fi
sed -i "s#DB_PASSWORD=.*#DB_PASSWORD=\"$LARANODE_RANDOM_PASS\"#" ".env"
sed -i "s#APP_URL=.*#APP_URL=\"http://$(curl icanhazip.com)\"#" ".env"
# Thiết lập charset/collation cho MySQL
mysql -u root -p"$ROOT_RANDOM_PASS" -e "ALTER DATABASE laranode CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p"$ROOT_RANDOM_PASS" laranode -e "ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p"$ROOT_RANDOM_PASS" laranode -e "ALTER TABLE users MODIFY name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
# Thêm charset/collation vào .env nếu chưa có
grep -q "DB_CHARSET" .env || echo "DB_CHARSET=utf8mb4" >> .env
grep -q "DB_COLLATION" .env || echo "DB_COLLATION=utf8mb4_unicode_ci" >> .env

if [ -f artisan ]; then
    php artisan key:generate
    php artisan migrate
    php artisan db:seed
    php artisan storage:link
    php artisan reverb:install
else
    echo "Không tìm thấy file artisan! Dừng cài đặt."
    exit 1
fi

sed -i "s#VITE_REVERB_HOST=.*#VITE_REVERB_HOST=$(curl icanhazip.com)#" ".env"
sed -i "s#REVERB_HOST=.*#REVERB_HOST=$(curl icanhazip.com)#" ".env"


if [ -f /home/laranode_ln/panel/laranode-scripts/templates/apache2-default.template ]; then
    cp /home/laranode_ln/panel/laranode-scripts/templates/apache2-default.template /etc/apache2/sites-available/000-default.conf
else
    echo "File apache2-default.template không tồn tại!"
fi

echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Hold tight, pouring node_modules with npm install & compiling assets"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
npm install
npm run build


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Adding systemd services (queue worker and reverb)"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"


if [ -f /home/laranode_ln/panel/laranode-scripts/templates/laranode-queue-worker.service ]; then
    cp /home/laranode_ln/panel/laranode-scripts/templates/laranode-queue-worker.service /etc/systemd/system/laranode-queue-worker.service
else
    echo "File laranode-queue-worker.service không tồn tại!"
fi
if [ -f /home/laranode_ln/panel/laranode-scripts/templates/laranode-reverb.service ]; then
    cp /home/laranode_ln/panel/laranode-scripts/templates/laranode-reverb.service /etc/systemd/system/laranode-reverb.service
else
    echo "File laranode-reverb.service không tồn tại!"
fi


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Kiểm tra và cài đặt UFW nếu chưa có, thêm rule cho SSH | HTTP | HTTPS | REVERB WEBSOCKETS"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
if ! command -v ufw >/dev/null 2>&1; then
    echo "UFW chưa được cài, tiến hành cài đặt..."
    apt install -y ufw
fi
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 8080


echo -e "\033[34m"
echo "--------------------------------------------------------------------------------"
echo "Setting permissions"
echo "--------------------------------------------------------------------------------"
echo -e "\033[0m"
mkdir -p /home/laranode_ln/logs
chown -R laranode_ln:laranode_ln /home/laranode_ln
find /home/laranode_ln -type d -exec chmod 770 {} \;
find /home/laranode_ln -type f -exec chmod 660 {} \;

if [ -d /home/laranode_ln/panel/laranode-scripts/bin ]; then
    find /home/laranode_ln/panel/laranode-scripts/bin -type f -exec chmod 100 {} \;
fi
if [ -d /home/laranode_ln/panel/storage ]; then
    find /home/laranode_ln/panel/storage -type d -exec chmod 775 {} \;
fi
if [ -d /home/laranode_ln/panel/bootstrap ]; then
    find /home/laranode_ln/panel/bootstrap -type d -exec chmod 775 {} \;
fi


systemctl daemon-reload
systemctl enable laranode-queue-worker.service
systemctl enable laranode-reverb.service
systemctl start laranode-queue-worker.service
systemctl start laranode-reverb.service
systemctl restart apache2
systemctl restart php8.4-fpm


echo "================================================================================"
echo "================================================================================"
echo -e "\033[32m --- NOTES ---\033[0m"

echo "MySQL Root Password: $ROOT_RANDOM_PASS"
echo "Laranode MySQL Username: laranode"
echo "Laranode MySQL Password: $LARANODE_RANDOM_PASS"

echo -e "\033[32m --- IMPORTANT ---\033[0m"

echo "Final Step: Automatically creating an admin account for Laranode..."


# Cho phép nhập thông tin admin có dấu (Unicode)

echo -e "\033[32m --- ADMIN INFO ---\033[0m"
echo "Admin Name: $ADMIN_NAME"
echo "Admin Email: $ADMIN_EMAIL"
echo "Admin Password: $ADMIN_PASS"

if [ -f artisan ]; then
    echo -e "\033[33m\n\n==============================="
    echo -e "\033[33mBước cuối: TẠO TÀI KHOẢN ADMIN\033[0m"
    echo -e "\033[33mVui lòng nhập thông tin trực tiếp theo hướng dẫn bên dưới:\033[0m"
    echo -e "\033[36mcd /home/laranode_ln/panel && php artisan laranode:create-admin\033[0m"
    echo -e "\033[33mSau đó nhập tên, email, mật khẩu admin theo yêu cầu.\033[0m"
    echo -e "===============================\033[0m\n"
else
    echo "Không tìm thấy file artisan! Không thể tạo tài khoản admin."
fi

echo "Panel đã được cài đặt thành công! Đăng nhập tại: http://$(curl icanhazip.com)/login"
echo "================================================================================"
echo "================================================================================"
