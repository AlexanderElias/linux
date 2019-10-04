
DISK_OUTPUT="$(parted -l | sed -En 's/Disk (\/dev\/\w+):.*/\1/p')"
DISKS=('' $DISK_OUTPUT)
DISKS_LENGTH="${#DISKS[*]}"

answer=""
while true; do
  echo
  for (( i=0; i < $DISKS_LENGTH; i++ )) do
    [ ${i} != 0 ] && echo "${i}) ${DISKS[i]}"
  done
  echo -ne "Type the disk number you would like to partition: "
  read answer
  [ "${DISKS[answer]}" != "" ] && break
  echo
  echo "Disk is required. Try again."
done
DISK="${DISKS[answer]}"

echo $DISK