$uri = Invoke-WebRequest "https://www.bbc.co.uk/sport/football/scores-fixtures"
$res = $uri.ParsedHtml.getElementsByClassName('gs-o-list-ui')
$links = ($res[0] | ForEach-Object{$_.getElementsByTagName('a')}).href -replace 'about:/', ''
$test = foreach($link in $links){
    "https://www.bbc.co.uk/$link"
}
$test