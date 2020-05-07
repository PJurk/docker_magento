rm -rf ./app
mkdir /c/app
docker cp my-magento:/var/www/html/. /c/app
mv /c/app $(pwd)