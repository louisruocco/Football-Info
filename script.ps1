$uri = Invoke-WebRequest "https://www.bbc.co.uk/sport/football/scores-fixtures"
$res = $uri.ParsedHtml.getElementsByClassName('gs-o-list-ui')
$links = ($res[0] | ForEach-Object{$_.getElementsByTagName('a')}).href -replace 'about:/', ''
foreach($link in $links){
    start-process msedge https://www.bbc.co.uk/$link
}