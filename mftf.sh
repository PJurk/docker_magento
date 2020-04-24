echo "Configuring for mftf"
docker exec -it my-magento bin/magento config:set cms/wysiwyg/enabled disabled
docker exec -it my-magento bin/magento config:set admin/security/admin_account_sharing 1
docker exec -it my-magento bin/magento config:set admin/security/use_form_key 0
docker exec -it my-magento bin/magento cache:clean config full_page
echo "Building mftf"
docker exec -it my-magento vendor/bin/mftf build:project
docker exec -it my-magento cp dev/tests/acceptance/.htaccess.sample dev/tests/acceptance/.htaccess
docker exec -it my-magento vendor/bin/mftf generate:tests
cp ./env.mftf ./app/dev/tests/acceptance/.env
docker exec -it my-magento vendor/bin/codecept run functional -c dev/tests/acceptance/codeception.yml