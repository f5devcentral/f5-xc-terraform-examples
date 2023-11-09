for run in {1..10}
do
 curl -s 'https://community.f5.com/t5/technical-articles/protecting-your-native-mobile-apps-with-f5-xc-mobile-app-shield/ta-p/319311' -i -X POST -d "username=1&password=1" 
 echo
 echo CURL Credential Stuffing attempt $run done
 sleep 2
done
