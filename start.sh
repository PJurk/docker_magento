#Use docker reset script if you are using docker toolbox, otherwise composer process inside the container will be killed

source ./env
WORKDIR=./app

PUBLIC_KEY=4e6887bd810261a9c6f04f6efa9b73dd
PRIVATE_KEY=bf2f47b7f4653053ab2cc827f78b26a0

if [ ! -f auth.json ]
then
    echo "{ \"http-basic\": { \"repo.magento.com\": {\"username\": \"$PUBLIC_KEY\",\"password\": \"$PRIVATE_KEY\"}}}" >> auth.json
fi

if [ ! -d $WORKDIR ]
then
    #./docker-reset.sh
    mkdir $WORKDIR
    echo "Creating magento project"
    cd app
    composer create-project --no-install --repository-url=https://repo.magento.com/ magento/project-community-edition .
    composer config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
    echo "Installing magento dependencies"
    composer install --no-interaction --ignore-platform-reqs
    chmod -R 777 ./
    cd ..
    docker-compose up -d --build
    docker exec -it my-magento composer config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
    echo "Deploying sample data"
    docker exec -it my-magento php -dmemory_limit=5G bin/magento sampledata:deploy  
    echo "Installing magento"
    docker exec -it my-magento bin/magento setup:install --base-url=$MAGENTO_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME --language=$MAGENTO_LANGUAGE --timezone=$MAGENTO_TIMEZONE --currency=$MAGENTO_DEFAULT_CURRENCY --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$MAGENTO_ADMIN_LASTNAME --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD
    echo "Configuring"
    docker exec -it my-magento bin/magento deploy:mode:set developer
    docker exec -it my-magento bin/magento indexer:reindex
    echo "Deploying static content"
    docker exec -it my-magento bin/magento setup:static-content:deploy -f
    docker exec -it my-magento chmod -R 777 ./
    echo "Magento ready, copying files from container"
    ./copyfromcontainer.sh
    echo "Ready"
else
    #If docker containers fails to build the first time due to http error
    docker-compose up -d --build
    docker exec -it my-magento composer config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
    echo "Deploying sample data"
    docker exec -it my-magento php -dmemory_limit=5G bin/magento sampledata:deploy  
    echo "Installing magento"
    docker exec -it my-magento bin/magento setup:install --base-url=$MAGENTO_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME --language=$MAGENTO_LANGUAGE --timezone=$MAGENTO_TIMEZONE --currency=$MAGENTO_DEFAULT_CURRENCY --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$MAGENTO_ADMIN_LASTNAME --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD
    echo "Configuring"
    docker exec -it my-magento bin/magento deploy:mode:set developer
    docker exec -it my-magento bin/magento indexer:reindex
    echo "Deploying static content"
    docker exec -it my-magento bin/magento setup:static-content:deploy -f
    docker exec -it my-magento chmod -R 777 ./
    echo "Magento ready, copying files from container"
    ./copyfromcontainer.sh
    echo "Ready"
fi
