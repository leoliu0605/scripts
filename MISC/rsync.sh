#!/bin/bash

src=""
dest=""
rsync -avh --ignore-existing --progress --stats --partial --append --log-file=rsync_log.txt ${src} ${dest}
