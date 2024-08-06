#!/bin/bash
set -e

# modified version of https://github.com/Pantonius/Discord-Update
url="https://discord.com/api/download?platform=linux&format=deb"
name="Discord"
debname="discord.deb"
tmpdir=$(mktemp -d /tmp/discord-update.XXXXXX)
last_hash="$(dirname $0)/last_discord_deb_sha"

function cleanup() {
    code=$1

    if [[ $code -gt 0 ]]; then
        echo "[$(date)] ERROR!!"
    else
        echo "[$(date)] Cleaning up..."
        if [[ $tmpdir != '/' ]]; then # do not delete root
            rm -r $tmpdir
        fi

        echo "[$(date)] Finished"
    fi
}

trap 'cleanup' EXIT

# create last hash file if it does not exist yet
touch $last_hash

# navigate to the temp directory
cd $tmpdir

echo "[$(date)] Getting latest version of $name from $url..."
wget -qO $debname "$url"

current_sha=$(sha256sum ${debname} | awk '{ print $1}')

if [[ $(cat $last_hash) == $current_sha ]]; then
    echo "[$(date)] There are no discord updates."
    exit 0
else
    echo "[$(date)] There are discord update!"
    echo "$current_sha" > $last_hash
fi

# kill all processes called discord
echo "[$(date)] Killing all processes called $name"
for KILLPID in `ps ax | grep $name | awk ' { print $1;}'`; do
    kill $KILLPID &> /dev/null
    sleep 10
done

# install the deb
echo "[$(date)] Installing $debname..."
sudo dpkg -i $debname
