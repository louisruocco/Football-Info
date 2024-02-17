$uri = Invoke-WebRequest "https://www.bbc.co.uk/sport/football/scores-fixtures"
$res = $uri.ParsedHtml.getElementsByClassName('gs-o-list-ui')
$links = ($res[0] | ForEach-Object{$_.getElementsByTagName('a')}).href -replace 'about:/', ''
$matches = foreach($link in $links){
    "<li>https://www.bbc.co.uk/$link</li>"
}

$username = (Get-Content "$PSScriptRoot\utils\username.txt")
$password = (Get-Content "$PSScriptRoot\utils\password.txt") | ConvertTo-SecureString -AsPlainText -Force
# $emailAddress = (Get-Content "$PSScriptRoot\utils\secrets.txt")[2]


$body = @"
<h1>Premier League Matches This Weekend</h1>
<p>Here are a list of football matches happening today</p>
<ul>
    $matches
</ul>
"@

$email = @{
    from = $username
    to = 'louisruocco1@gmail.com'
    subject = "Noremier League Matches This Weekend"
    smtpserver = "smtp.gmail.com"
    body = $body
    port = 587
    credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $password
    usessl = $true
    verbose = $true
}

Send-MailMessage @email -BodyAsHtml