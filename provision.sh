# Create swap (composer takes up a lot of memory)
sudo fallocate -l 1G /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo su -c "echo '/swapfile   none    swap    sw    0   0' >> /etc/fstab"

# Update repos
sudo apt-get update

# Install Git and PHP5
sudo apt-get install -y git-core subversion curl php5-cli php5-curl php5-mcrypt php5-gd

# Setup MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y php5-mysql mysql-server

# Install Apache2
sudo apt-get install -y apache2 libapache2-mod-php5

# Enable MCrypt
sudo ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/cli/conf.d/20-mcrypt.ini
sudo ln -s /etc/php5/mods-available/mcrypt.ini /etc/php5/apache2/conf.d/20-mcrypt.ini

# Enable Rewrite
sudo a2enmod rewrite

# Configure our site's Apache Config
sudo -s
cat <<EOF > /etc/apache2/sites-available/000-default.conf

<VirtualHost *:80>
    DocumentRoot /var/www/public
    <Directory /var/www/public>
        Options All
        AllowOverride All
    </Directory>
</VirtualHost>

EOF

# Configure our other shit
sudo rm -rf '/var/www/html'
sudo sed -i -e 's/bind-address/#bind-address/g' /etc/mysql/my.cnf
sudo mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'; flush privileges;"
sudo mysql -u root -proot -e 'CREATE DATABASE yourapplication;'

# Restart Apache and MySQL
sudo service mysql restart
sudo service apache2 restart

# Install composer dependencies and seed application
cd /var/www && php composer.phar install
php artisan migrate --seed