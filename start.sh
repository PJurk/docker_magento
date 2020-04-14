export WORKDIR=./app
if [ ! -d $WORKDIR ]
then
    mkdir $WORKDIR
    cd $WORKDIR
    composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .
    composer config http-basic.repo.magento.com adf97a28c4f6f0c1e6a8f3d9f11cc448 bdec1caff6c7d5632054b1c08ed4cf7b
    /bin/magneto sampledata:deploy
    cd ..
    docker-compose up -d
    docker exec -it my-magento chmod u+x bin/magento
    docker exec -it my-magento composer config http-basic.repo.magento.com adf97a28c4f6f0c1e6a8f3d9f11cc448 bdec1caff6c7d5632054b1c08ed4cf7b
    docker exec -it my-magento /bin/magento setup:install --base-url=$MAGENTO_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME --language=$MAGENTO_LANGUAGE --timezone=$MAGENTO_TIMEZONE --currency=$MAGENTO_DEFAULT_CURRENCY --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --use-secure=$MAGENTO_USE_SECURE --base-url-secure=$MAGENTO_BASE_URL_SECURE --use-secure-admin=$MAGENTO_USE_SECURE_ADMIN --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$MAGENTO_ADMIN_LASTNAME --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD
else
    docker-compose up -d
fi





#docker exec -it my-magento find . -type d -exec chmod 770 {} \;
#docker exec -it my-magento find . -type f -exec chmod 660 {} \; 
#docker exec -it my-magento chmod u+x bin/magento
#docker exec -it my-magento composer config http-basic.repo.magento.com adf97a28c4f6f0c1e6a8f3d9f11cc448 bdec1caff6c7d5632054b1c08ed4cf7b
#docker exec -it my-magento /bin/magento setup:install --base-url=$MAGENTO_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME --language=$MAGENTO_LANGUAGE --timezone=$MAGENTO_TIMEZONE --currency=$MAGENTO_DEFAULT_CURRENCY --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --use-secure=$MAGENTO_USE_SECURE --base-url-secure=$MAGENTO_BASE_URL_SECURE --use-secure-admin=$MAGENTO_USE_SECURE_ADMIN --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$MAGENTO_ADMIN_LASTNAME --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD
