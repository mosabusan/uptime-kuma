# Description: Update cloudcircus dist from github pull request
# Similar to `extra/download-dist.js`
# but this script is for cloudcircus
#
# Usage: sh update-cloudcircus.sh <download url>

if [ -z $1 ]; then
    echo "Error: Need download url as argument"
    exit 1
fi

echo "====================="
echo "Update git repository"
echo ""
git fetch --all
git checkout cloudcircus
git pull origin cloudcircus


echo ""
echo "====================="
echo "Install dependencies"
echo ""
npm install --production


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

# download dist zip from github
curl -OL $1

if [ $? -ne 0 ]; then
    # if error
    echo ""
    echo "Error: Failed to download dist"
    # rollback
    mv $BACKUP_DIR $DIST_DIR
    exit 1
fi


echo ""
echo "====================="
echo "Unzip release dist"
echo ""
tar -zxvf $ZIP_FILE

if [ $? -ne 0 ]; then
    # if error
    echo ""
    echo "Error: Failed to unzip downloaded dist"
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
