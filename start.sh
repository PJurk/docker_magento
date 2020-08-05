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
    mkdir $WORKDIR
    echo "Creating magento project"
    cd app
    composer create-project --no-install --repository-url=https://repo.magento.com/ magento/project-community-edition .
    composer config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
    echo "Installing magento dependencies"
    composer install --no-interaction --ignore-platform-reqs
    cd ..
    docker-compose up -d --build
    docker exec -it my-magento composer config http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY
    echo "Deploying sample data"
    # docker exec -it my-magento php -dmemory_limit=5G bin/magento sampledata:deploy  
    echo "Installing magento"
    chmod -R 777 ./
    # . ./Scripts/install.sh
    echo "Ready"
else
    docker-compose up -d --build
fi
