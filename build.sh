#!/bin/bash

branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

# Make store version
rm -rf EnderecoShopware6ClientStore
rsync -ar --exclude 'vendor' --exclude 'node_modules' --exclude 'shops' ./* ./EnderecoShopware6ClientStore

# Clean up
rm -rf EnderecoShopware6ClientStore/node_modules
rm EnderecoShopware6ClientStore/.gitignore
rm EnderecoShopware6ClientStore/.idea
rm EnderecoShopware6ClientStore/*.sh
rm EnderecoShopware6ClientStore/docker-compose.yml
rm EnderecoShopware6ClientStore/endereco.js
rm EnderecoShopware6ClientStore/endereco.scss
rm EnderecoShopware6ClientStore/package.json
rm EnderecoShopware6ClientStore/package-lock.json
rm EnderecoShopware6ClientStore/webpack.config.js

# Rename
find ./EnderecoShopware6ClientStore -type f -exec sed -i 's/Shopware6Client/Shopware6ClientStore/g' {} \;
find ./EnderecoShopware6ClientStore -type f -exec sed -i 's/ (Download)//g' {} \;
find ./EnderecoShopware6ClientStore -type f -exec sed -i 's/endereco-shopware6-client/endereco-shopware6-client-store/g' {} \;
find ./EnderecoShopware6ClientStore -type f -exec sed -i 's/endereco_shopware6_client/endereco_shopware6_client_store/g' {} \;
find ./EnderecoShopware6ClientStore -type f -exec sed -i 's/enderecoshopware6client/enderecoshopware6clientstore/g' {} \;
mv ./EnderecoShopware6ClientStore/src/EnderecoShopware6Client.php ./EnderecoShopware6ClientStore/src/EnderecoShopware6ClientStore.php
mv ./EnderecoShopware6ClientStore/src/Resources/public/administration/js/endereco-shopware6-client.js ./EnderecoShopware6ClientStore/src/Resources/public/administration/js/endereco-shopware6-client-store.js


# Find all Twig files and process them
TWIG_FILES_PATH="./EnderecoShopware6ClientStore/src/Resources/views"
find "$TWIG_FILES_PATH" -type f -name "*.twig" | while read -r file; do
    # Remove single-line JavaScript comments
    sed -i '/\/\/.*/d' "$file"

    # Remove multi-line JavaScript comments
    # This is more complex and might not work correctly for all cases
    sed -i '/\/\*\*/,/\*\//d' "$file"
done

zip -r EnderecoShopware6ClientStore-$branch.zip EnderecoShopware6ClientStore
rm -rf EnderecoShopware6ClientStore

# Make github version
rm -rf EnderecoShopware6Client
rsync -ar --exclude 'vendor' --exclude 'node_modules' --exclude 'shops' --exclude "EnderecoShopware6ClientStore-$branch.zip" ./* ./EnderecoShopware6Client

# Clean up
rm -rf EnderecoShopware6Client/node_modules
rm EnderecoShopware6Client/.gitignore
rm EnderecoShopware6Client/.idea
rm EnderecoShopware6Client/build.sh
rm EnderecoShopware6Client/docker-compose.yml
rm EnderecoShopware6Client/endereco.js
rm EnderecoShopware6Client/endereco.scss
rm EnderecoShopware6Client/package.json
rm EnderecoShopware6Client/package-lock.json
rm EnderecoShopware6Client/webpack.config.js
TWIG_FILES_PATH="./EnderecoShopware6Client/src/Resources/views"
find "$TWIG_FILES_PATH" -type f -name "*.twig" | while read -r file; do
    # Remove single-line JavaScript comments
    sed -i '/\/\/.*/d' "$file"

    # Remove multi-line JavaScript comments
    # This is more complex and might not work correctly for all cases
    sed -i '/\/\*\*/,/\*\//d' "$file"
done

zip -r EnderecoShopware6Client-$branch.zip EnderecoShopware6Client
rm -rf EnderecoShopware6Client