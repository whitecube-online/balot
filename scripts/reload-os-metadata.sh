for i in {1..306}
do
  curl -i -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" \
    "https://api.opensea.io/api/v1/asset/0x6b877dfaf74b22913a494d1fc95d7e30c2b88ea1/$i/?force_update=true"
done

