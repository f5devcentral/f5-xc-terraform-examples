for run in {1..10}
do
 curl -s 'https://abcdefg.cloudfront.net/user/signin' -i -X POST -d "username=1&password=1" 
 echo
 echo CURL Credential Stuffing attempt $run done
 sleep 2
done
