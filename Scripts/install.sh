source ./env
docker exec -it my-magento bin/magento setup:install --base-url=$MAGENTO_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME --language=$MAGENTO_LANGUAGE --timezone=$MAGENTO_TIMEZONE --currency=$MAGENTO_DEFAULT_CURRENCY --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$MAGENTO_ADMIN_LASTNAME --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD
docker exec -it my-magento bin/magento deploy:mode:set developer
docker exec -it my-magento bin/magento module:disable Magento_TwoFactorAuth
docker exec -it my-magento bin/magento cache:flush
chmod -R 777 ./