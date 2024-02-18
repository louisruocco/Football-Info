$headers = @{
    "X-Auth-Token" = "d639bd2e154c4087ab3b9c20d016e262"
}

$res = Invoke-RestMethod "https://api.football-data.org/v4/matches" -Method Get -Headers $headers
$match = $res.matches | Where-Object {$_.competition.name -eq 'Premier League'}
$todayGames = foreach($game in $match){
    $hometeam = $game.homeTeam.name
    $awayteam = $game.awayTeam.name
    $time = $game.utcDate
    "<li>$hometeam vs $awayTeam | $time</li>"
}



$username = (Get-Content "$PSScriptRoot\utils\username.txt")
$password = (Get-Content "$PSScriptRoot\utils\password.txt") | ConvertTo-SecureString -AsPlainText -Force
# $emailAddress = (Get-Content "$PSScriptRoot\utils\secrets.txt")[2]


$body = @"
<h1>Premier League Matches This Weekend</h1>
<p>Here are a list of football matches happening today</p>
<ul>
    $todayGames
</ul>
"@

$email = @{
    from = $username
    to = 'louisruocco1@gmail.com'
    subject = "Premier League Matches This Weekend"
    smtpserver = "smtp.gmail.com"
    body = $body
    port = 587
    credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $password
    usessl = $true
    verbose = $true
}

Send-MailMessage @email -BodyAsHtml