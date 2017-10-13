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
    --worker-sdd)
    WORKER_SDD="$2"
    shift # past argument
    ;;
    --worker-sdd-dir)
    WORKER_SDD_DIR="$2"
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
    echo "Worker memory not supplied. Default to `16GB`"
    WORKER_MEM=16GB
fi

if [ -z "$WORKER_SDD" ]; then
    echo "Worker SDD size not supplied. Default to `100GB`"
    WORKER_SDD=100GB
fi

if [ -z "$WORKER_SDD_DIR" ]; then
    echo "Worker SDD dir not supplied. Default to `/hadoopfs/fs2`"
    WORKER_SDD_DIR=/hadoopfs/fs2
fi

echo "Alluxio installed dir: $ALLUXIO_DIR"
echo "Master hostname: $MASTER"
echo "Worker memory: $WORKER_MEM"
echo "Worker SDD: $WORKER_SDD"
echo "Worker SDD directory: $WORKER_SDD_DIR"
echo "Mount worker: $MOUNT_WORKER"

echo "Configuring .. $ALLUXIO_DIR/conf/alluxio-site.properties"
sudo -u alluxio cat $ALLUXIO_DIR/conf/alluxio-site.properties.template | \
    sed "s/{{master}}/$MASTER/g" | \
    sed "s/{{worker-sdd}}/$WORKER_SDD/g" | \
    sed "s|{{worker-sdd-dir}}|$WORKER_SDD_DIR|g" | \
    sed "s/{{worker-mem}}/$WORKER_MEM/g" \
    > $ALLUXIO_DIR/conf/alluxio-site.properties

# only mount worker's ramdisk and hdd if specified
if [ "$MOUNT_WORKER" = true ]; then
    echo "Mounting ramfs for local worker using configured setting in $ALLUXIO_DIR/conf/alluxio-site.properties"
    $ALLUXIO_DIR/bin/alluxio-mount.sh Mount local
fi
