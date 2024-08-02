for run in {1..10}
do
  echo "Running commands against website Address - $1"
  curl -s "$1" -i -X POST -d "username=1&password=1"
  sleep 10
  echo CURL Credential Stuffing attempt "$run" done
  sleep 2
done
