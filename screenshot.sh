scan(){
while read domain; do
  http="http://"$domain
  https="https://"$domain":443"
  echo "[+] Taking Screen Shot of $domain"
  http_screenshot=$(curl -s "https://www.googleapis.com/pagespeedonline/v2/runPagespeed?url="$http"&screenshot=true" | jq -r '.screenshot.data' | sed "s/_/\//g" | sed "s/-/+/g" )
  echo "+ Port 80 Done"
  https_screenshot=$(curl -s "https://www.googleapis.com/pagespeedonline/v2/runPagespeed?url="$https"&screenshot=true" | jq -r '.screenshot.data' | sed "s/_/\//g" | sed "s/-/+/g" )
  echo "+ Port 443 Done"
  http_image="<img src=\"data:image/jpeg;base64,"$http_screenshot"\" class='img-responsive img-thumbnail'/>";
  https_image="<img src=\"data:image/jpeg;base64,"$https_screenshot"\" class='img-responsive img-thumbnail'/>";
  echo '<tr class="table-active">' >> $report
  echo '<td><br><br><span style="font-size: 22px">'$domain'</span><br><a href=http://127.0.0.1/reconer/src/Dragon.php?recon='$domain' target="_blank">Recon-Dragon</a></td>' >> $report
  echo '<td>'$http_image'</td>' >> $report
#  echo '<td>-</td>' >> $report
  echo '<td>'$https_image'</td>' >> $report
  echo '</tr>' >> $report
done < $1
echo "</table>" >> $report
echo "</body></html>" >> $report
}

main(){
echo '<!DOCTYPE html><html>
<head>
  <link rel="stylesheet" href="https://bootswatch.com/4/darkly/bootstrap.min.css" />
  <script src="https://bootswatch.com/_vendor/jquery/dist/jquery.min.js"></script>
  <script src="https://bootswatch.com/_vendor/popper.js/dist/umd/popper.min.js"></script>
  <script src="https://bootswatch.com/_vendor/bootstrap/dist/js/bootstrap.min.js"></script>
  <link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Mina' rel='stylesheet'>
<body>
<meta charset="utf-8"> <meta name="viewport" content="width=device-width, initial-scale=1"> <link rel="stylesheet" href="bootstrap.min.css"> <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script> <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script></body>
</head>
<style>
th, td {
  text-align: center;
  font-size: 18px;
}
</style>
<body>' >> $report
echo '<div class="jumbotron text-center"><h1><span style="color: #fff;">Screenshots for '$1'</h1><br><br>' >> $report
echo '<table class="table table-hover"><thead><tr><th scope"col">Domain</th><th scope="col">Port 80</th><th scope="col">Port 443</th></tr><thead>' >> $report
scan $1
}
touch /root/reports/$1/screenshots.html
report="/root/reports/$1/screenshots.html"
main $1
