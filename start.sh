source ./env
WORKDIR=./app
if [ ! -d $WORKDIR ]
then
    mkdir $WORKDIR
    docker-compose up -d --build
    docker exec -it my-magento chmod -R 755 .
    docker exec -it my-magento composer create-project --no-install --repository-url=https://repo.magento.com/ magento/project-community-edition .
    #docker run --rm -it -m 2g --oom-kill-disable  --volume /$PWD/app:/app composer install --ignore-platform-reqs
    cd app
    composer install --ignore-platform-reqs
    cd ..
    docker exec -it my-magento composer config http-basic.repo.magento.com 4e6887bd810261a9c6f04f6efa9b73dd bf2f47b7f4653053ab2cc827f78b26a0
    docker exec -it my-magento bin/magento sampledata:deploy
    docker exec -it my-magento chmod u+x bin/magento
    docker exec -it my-magento bin/magento setup:install --base-url=$MAGENTO_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME --language=$MAGENTO_LANGUAGE --timezone=$MAGENTO_TIMEZONE --currency=$MAGENTO_DEFAULT_CURRENCY --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --use-secure=$MAGENTO_USE_SECURE --base-url-secure=$MAGENTO_BASE_URL_SECURE --use-secure-admin=$MAGENTO_USE_SECURE_ADMIN --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$MAGENTO_ADMIN_LASTNAME --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD
else
    docker-compose up -d
fi




# https://community.magento.com/t5/Installing-Magento-2-x/There-has-been-an-error-processing-your-request/td-p/110254
#docker exec -it my-magento find . -type d -exec chmod 770 {} \;
#docker exec -it my-magento find . -type f -exec chmod 660 {} \; 
#docker exec -it my-magento chmod u+x bin/magento
#docker exec -it my-magento composer config http-basic.repo.magento.com adf97a28c4f6f0c1e6a8f3d9f11cc448 bdec1caff6c7d5632054b1c08ed4cf7b
#docker exec -it my-magento /bin/magento setup:install --base-url=$MAGENTO_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME --language=$MAGENTO_LANGUAGE --timezone=$MAGENTO_TIMEZONE --currency=$MAGENTO_DEFAULT_CURRENCY --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --use-secure=$MAGENTO_USE_SECURE --base-url-secure=$MAGENTO_BASE_URL_SECURE --use-secure-admin=$MAGENTO_USE_SECURE_ADMIN --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$MAGENTO_ADMIN_LASTNAME --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD
