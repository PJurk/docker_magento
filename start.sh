
ln -s /mnt/c/Program\ Files/Docker/Docker/resources/bin/docker-credential-desktop.exe /usr/bin/docker-credential-desktop.exe

source ./env
WORKDIR=./app

if [ ! -f ./Docker/Magento/auth.json ]
then
    echo "{ \"http-basic\": { \"repo.magento.com\": {\"username\": \"$PUBLIC_KEY\",\"password\": \"$PRIVATE_KEY\"}}}" >> ./Docker/Magento/auth.json
fi

if [ ! -d $WORKDIR ]
then
    echo "Creating magento project"
    docker-compose up -d --build
    docker exec -it my-magento composer create-project --no-install --repository-url=https://repo.magento.com/ magento/project-community-edition=2.3.5 .
    docker exec -it my-magento composer config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
    echo "Installing magento dependencies"
    docker exec -it my-magento composer install --no-interaction --ignore-platform-reqs
    if [ "$DEPLOY_SAMPLE_DATA" = true ]
        then
        echo "Deploying sample data"
        docker exec -it my-magento php -dmemory_limit=5G bin/magento sampledata:deploy  
        fi
    echo "Installing magento"
    chmod -R 777 ./
    . ./Scripts/install.sh
    echo "Ready"
else
    docker-compose up -d
fi
