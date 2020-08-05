# echo "Setting perms"
docker exec -it my-magento chmod -R 777 .
echo "Clearing cache"
docker exec -it my-magento rm -rf var/cache/*
echo "Compiling di"
docker exec -it my-magento bin/magento setup:di:compile