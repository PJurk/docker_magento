# https://github.com/Smile-SA/elasticsuite/wiki/ModuleInstall

docker exec -it my-magento composer require elasticsearch/elasticsearch 6.7.2
docker exec -it my-magento composer require smile/elasticsuite 2.8.8
docker exec -it my-magento bin/magento module:enable Smile_ElasticsuiteCore Smile_ElasticsuiteCatalog Smile_ElasticsuiteSwatches Smile_ElasticsuiteCatalogRule Smile_ElasticsuiteVirtualCategory Smile_ElasticsuiteThesaurus Smile_ElasticsuiteCatalogOptimizer Smile_ElasticsuiteTracker Smile_ElasticsuiteAnalytics Smile_ElasticsuiteAdminNotification

# docker exec -it my-magento bin/magento module:disable Smile_ElasticsuiteCore Smile_ElasticsuiteCatalog Smile_ElasticsuiteSwatches Smile_ElasticsuiteCatalogRule Smile_ElasticsuiteVirtualCategory Smile_ElasticsuiteThesaurus Smile_ElasticsuiteCatalogOptimizer Smile_ElasticsuiteTracker Smile_ElasticsuiteAnalytics Smile_ElasticsuiteAdminNotification

# docker exec -it my-magento composer remove smile/elasticsuite

docker exec -it my-magento bin/magento config:set -l smile_elasticsuite_core_base_settings/es_client/servers elasticsearch:9200
docker exec -it my-magento bin/magento config:set -l smile_elasticsuite_core_base_settings/es_client/enable_https_mode 0
docker exec -it my-magento bin/magento config:set -l smile_elasticsuite_core_base_settings/es_client/enable_http_auth 0
docker exec -it my-magento bin/magento config:set -l smile_elasticsuite_core_base_settings/es_client/http_auth_user ""
docker exec -it my-magento bin/magento config:set -l smile_elasticsuite_core_base_settings/es_client/http_auth_pwd ""

docker exec -it my-magento bin/magento app:config:import

docker exec -it my-magento bin/magento setup:upgrade 

#Reindex

# docker exec -it my-magento bin/magento index:reindex catalogsearch_fulltext
# docker exec -it my-magento bin/magento index:reindex elasticsuite_categories_fulltext
# docker exec -it my-magento bin/magento index:reindex elasticsuite_thesaurus