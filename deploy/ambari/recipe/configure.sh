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
    --worker-mem)
    WORKER_MEM="$2"
    shift # past argument
    ;;
    --mount-worker)
    MOUNT_WORKER=true
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

if [ -z "$WORKER_MEM" ]; then
    echo "Worker memory not supplied. Default to `16G`"
    WORKER_MEM=16GB
fi

echo "Alluxio installed dir: $ALLUXIO_DIR"
echo "Master hostname: $MASTER"
echo "Worker memory: $WORKER_MEM"
echo "Mount worker: $MOUNT_WORKER"

echo "Configuring .. $ALLUXIO_DIR/conf/alluxio-site.properties"
sudo -u alluxio cat $ALLUXIO_DIR/conf/alluxio-site.properties.template | \
    sed "s/{{master}}/$MASTER/g" | \
    sed "s/{{worker-mem}}/$WORKER_MEM/g" \
    > $ALLUXIO_DIR/conf/alluxio-site.properties

# only mount worker's ramdisk and hdd if specified
if [ "$MOUNT_WORKER" = true ]; then
    echo "Mounting ramfs for local worker using configured setting in $ALLUXIO_DIR/conf/alluxio-site.properties"
    $ALLUXIO_DIR/bin/alluxio-mount.sh Mount local
fi
