# Description: Update cloudcircus dist from github release
# Similar to `extra/download-dist.js`
# but this script is for cloudcircus

echo "====================="
echo "Update git repository"
echo ""
git fetch --all
git checkout cloudcircus

# change version if necessary
VERSION=v0.1.0-cloudcircus

DIST_DIR=dist
BACKUP_DIR=dist-backup
ZIP_FILE=dist.tar.gz


echo ""
echo "====================="
echo "Download release dist from github"
echo ""
# backup dist
if [ -d $DIST_DIR ]; then
    if [ -d $BACKUP_DIR ]; then
        # remove old backup
        rm -rf $BACKUP_DIR
    fi
    # backup
    mv $DIST_DIR $BACKUP_DIR
fi

# download release dist as zip from github
curl -OL https://github.com/startialab-inc/uptime-kuma/releases/download/$VERSION/$ZIP_FILE


echo ""
echo "====================="
echo "Unzip release dist"
echo ""
tar -zxvf $ZIP_FILE

if [ $? -ne 0 ]; then
    # if error
    echo ""
    echo "Error: Failed to download release dist from github"
    # rollback
    mv $BACKUP_DIR $DIST_DIR
    exit 1
else
    # Done
    echo ""
    echo "Done"
    # remove backup
    rm -rf $BACKUP_DIR
fi

# remove zip file
rm -rf $ZIP_FILE

exit 0
