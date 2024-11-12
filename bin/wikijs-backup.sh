#!/bin/sh

export TEMP_DIR_HOST="/home/isaiah/git/organize-me/terraform-wikijs/tmp"

# Clean up
cleanup () {
  echo "Cleanup Start"

  # Delete the temporary directory
  if [ -d "$TEMP_DIR_HOST" ]; then
    rm -rf "$TEMP_DIR_HOST"
  fi

  echo "Cleanup Complete"
}

# Halt the script
halt () {
  # $1 - Exit code (optional)
  # $2 - Message (optional)

  if [ -n "$1" ]; then
    EXIT_CODE=$1
  else
    EXIT_CODE=0
  fi

  cleanup

  # Exit
  if [ "$EXIT_CODE" -ne 0 ]; then
    if [ -n "$2" ]; then
      echo "Backup Failed: $2"
    else
      echo "Backup Failed"
    fi
  fi
  exit "$EXIT_CODE"
}

# Create backup directory
backup() {
  mkdir -p "$TEMP_DIR_HOST/data" || halt 1 "Failed to create temporary directory"
  cd "$TEMP_DIR_HOST" || halt 1 "Failed to change directory"

  docker run --rm \
    --name "wikijs-backup" \
    --network "test" \
    --entrypoint "pg_dump" \
    --env "PGPASSWORD=password" \
    "postgres:17" \
    -U "wikijs" -h "postgres" -p "5432" -d "wikijs" \
     > "./data/backup.sql" || halt 1 "Failed to backup database"

  cd "./data" || halt 1 "Failed to change directory"
  tar -zcvf "$TEMP_DIR_HOST/wikijs-backup.tar.gz" .
  cd "$WORK_DIR" || halt 1 "Failed to change directory"
}

# Upload backup to S3
# Upload to S3
upload_archive_to_s3 () {
  # Upload to S3
  echo "Upload Start"

  export TEMP_DIR_AWSCLI="/tmp/backup"

  set -- "--rm"
  set -- "$@" "--name" "pihole_backup"
  set -- "$@" "--volume" "$TEMP_DIR_HOST:$TEMP_DIR_AWSCLI:ro"

  # AWS Directory (if exists)
  if [ -d "$HOME/.aws" ]; then
    set -- "$@" "--volume" "$HOME/.aws:/root/.aws:ro"
  fi

  # AWS DEFAULT REGION (if exists)
  if [ -n "$AWS_DEFAULT_REGION" ]; then
    set -- "$@" "--env" "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION"
  fi

  if [ -n "$AWS_S3_ENDPOINT_URL" ]; then
    set -- "$@" "--env" "AWS_S3_ENDPOINT_URL=$AWS_S3_ENDPOINT_URL"
  fi

  # AWS ACCESS KEY ID (if exists)
  if [ -n "$AWS_ACCESS_KEY_ID" ]; then
    set -- "$@" "--env" "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
  fi

  # AWS SECRET ACCESS KEY (if exists)
  if [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
    set -- "$@" "--env" "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
  fi

  CMD="s3"
  [ -n "$AWS_S3_ENDPOINT_URL" ] && CMD="s3 --endpoint-url $AWS_S3_ENDPOINT_URL"
  CMD="$CMD cp $TEMP_DIR_AWSCLI/wikijs-backup.tar.gz s3://wikijs-test-bucket/wikijs-backup.tar.gz"

  docker run "$@" "amazon/aws-cli:2.18.9" $CMD || halt 1 "006 : Unable to upload backup archive to S3"

  echo "Upload Complete"
}

run() {
  backup
  upload_archive_to_s3
  cleanup
}

# Capture start time
START_TIME=$(date +%s)

# Ensure elapsed time is displayed on exit
trap 'ELAPSED_TIME=$(($(date +%s) - $START_TIME)); echo "Execution time: $ELAPSED_TIME seconds"' EXIT

# Run the backup process
run