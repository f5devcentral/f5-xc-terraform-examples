for run in {1..10}
do
 curl -s 'http://ves-io-your-domain.ac.vh.ves.io/login' -i -X POST -d "username=1&password=1" 
 echo
 echo CURL Credential Stuffing attempt $run done
 sleep 2
done
