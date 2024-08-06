#!/bin/bash
set -e

# modified version of https://github.com/Pantonius/Discord-Update
url="https://discord.com/api/download?platform=linux&format=deb"
name="Discord"
debname="discord.deb"
tmpdir=$(mktemp -d /tmp/discord-update.XXXXXX)
last_hash="$(dirname $0)/last_discord_deb_sha"

function cleanup() {
    code=$?

    echo "[$(date -Iseconds)] Cleaning up..."
    if [[ $tmpdir != '/' ]]; then # do not delete root
        rm -r $tmpdir
    fi

    if [[ $code -gt 0 ]]; then
        echo "[$(date -Iseconds)] ERROR!!"
    else
        echo "[$(date -Iseconds)] Done!"
    fi
}

# run cleanup on exit
trap 'cleanup' EXIT

# create last hash file if it does not exist yet
touch $last_hash

# navigate to the temp directory
cd $tmpdir

echo "[$(date -Iseconds)] Getting latest version of $name..."
wget -qO $debname "$url"

current_sha=$(sha256sum ${debname} | awk '{ print $1}')

# check if hash matches with the last one
if [[ $(cat $last_hash) == $current_sha ]]; then
    echo "[$(date -Iseconds)] There is no discord update."
    exit 0
else
    echo "[$(date -Iseconds)] There is a discord update!"
    echo "$current_sha" > $last_hash
fi

# kill all processes called discord
echo "[$(date -Iseconds)] Killing all processes called $name"
for KILLPID in `ps ax | grep $name | awk ' { print $1;}'`; do
    kill $KILLPID &> /dev/null
    sleep 10
done

# install the deb file
echo "[$(date -Iseconds)] Installing $debname..."
sudo dpkg -i $debname
