#!/usr/bin/env bash
set -e

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    --hue-dir)
    ALLUXIO_DIR="$2"
    shift # past argument
    ;;
    --master-hostname)
    MASTER="$2"
    shift # past argument
    ;;
    *)
    echo "Unknown option $key"
    exit -1
    ;;
esac
shift
done

# Get hue install dir
if [ -z "$ALLUXIO_DIR" ]; then
    echo "Alluxio install dir not supplied. Default to /opt/alluxio"
    ALLUXIO_DIR=/opt/alluxio
fi

if [ -z "$MASTER" ]; then
    echo "Master hostname not supplied. Default to `hostname`"
    MASTER=`hostname`
fi

echo "Alluxio installed dir: $ALLUXIO_DIR"
echo "Master hostname: $MASTER"

echo "Configuring .. $ALLUXIO_DIR/conf/alluxio-site.properties"
cat $ALLUXIO_DIR/conf/alluxio-site.properties.template | \
    sed "s/{{master}}/$MASTER/g" \
    > $ALLUXIO_DIR/conf/alluxio-site.properties

echo "Mounting ramfs for local worker using configured setting in $ALLUXIO_DIR/conf/alluxio-site.properties"
$ALLUXIO_DIR/bin/alluxio-mount.sh Mount local
