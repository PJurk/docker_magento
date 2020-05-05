source ./env
WORKDIR=./app

PUBLIC_KEY=4e6887bd810261a9c6f04f6efa9b73dd
PRIVATE_KEY=bf2f47b7f4653053ab2cc827f78b26a0

if [ ! -f ./auth.json ]
then
    echo "{ \"http-basic\": { \"repo.magento.com\": {\"username\": \"$PUBLIC_KEY\",\"password\": \"$PRIVATE_KEY\"}}}" >> auth.json
fi

if [ ! -d $WORKDIR ]
then
    mkdir $WORKDIR
    docker-compose build --build-arg userID=$(id -u)
    docker-compose up -d 
    #docker exec -it my-magento chmod -R 755 .
    echo "Creating magento project"
    docker exec -it my-magento composer create-project --no-install --repository-url=https://repo.magento.com/ magento/project-community-edition .   
    #docker run --rm -it -m 2g --oom-kill-disable  --volume /$PWD/app:/app composer install --ignore-platform-reqs
    cd app
    composer config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
    echo "Installing magento dependencies"
    composer install --no-interaction --ignore-platform-reqs
    cd ..
    docker exec -it my-magento composer config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
    echo "Configuring magento user"
    #docker exec -it my-magento chown -R magento /var/www/html
    #docker exec -it my-magento chmod -R 775 /var/www/html/
    docker exec -it my-magento chmod u+x bin/magento
    echo "Deploying sample data"
    docker exec -it my-magento php -dmemory_limit=5G bin/magento sampledata:deploy  
    echo "Install magento now"
    #docker exec -it my-magento bin/magento setup:install --base-url=$MAGENTO_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME --language=$MAGENTO_LANGUAGE --timezone=$MAGENTO_TIMEZONE --currency=$MAGENTO_DEFAULT_CURRENCY --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$MAGENTO_ADMIN_LASTNAME --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD
    echo "Magento installed"
else
    docker-compose up -d
fi