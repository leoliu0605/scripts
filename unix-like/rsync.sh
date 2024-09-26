#!/bin/bash

source_path=""
destination_path=""
rsync -avh --ignore-existing --progress --stats --partial --append --log-file=rsync_log.txt ${source_path} ${destination_path}
