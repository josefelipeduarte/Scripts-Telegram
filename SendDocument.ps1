#Informações do script
#O arquivo tem de possuir dados, arquivo vazio não é enviado.
#Deve gerar um BOT por exemplo no BotFather para poder


# Configurações
$BotToken = '6397064394:AAFqhYc_f8ghVK5g2lSV08CCcJu7K30Tuos'
$ChatID = '-1001948144841'
$FilePath = 'basedados.sql'


# Verifica se o arquivo existe
if (-not (Test-Path $FilePath)) {
    Write-Host "Arquivo não encontrado: $FilePath"
    exit 1
}

# Lê o conteúdo do arquivo em bytes
$fileBytes = [System.IO.File]::ReadAllBytes($FilePath)

# Monta o corpo da requisição
$boundary = "----WebKitFormBoundary" + [Guid]::NewGuid().ToString()
$Body = "--$boundary`r`n" +
        "Content-Disposition: form-data; name=`"chat_id`"`r`n`r`n" +
        "$ChatID`r`n" +
        "--$boundary`r`n" +
        "Content-Disposition: form-data; name=`"document`"; filename=`"$(Split-Path -Leaf $FilePath)`"`r`n" +
        "Content-Type: application/octet-stream`r`n`r`n" +
        [System.Text.Encoding]::UTF8.GetString($fileBytes) + "`r`n" +
        "--$boundary--`r`n"

# URL da API do Telegram
$Uri = "https://api.telegram.org/bot$BotToken/sendDocument"

# Envia a requisição
try {
    $response = Invoke-RestMethod -Uri $Uri -Method Post -Body ([System.Text.Encoding]::UTF8.GetBytes($Body)) -ContentType "multipart/form-data; boundary=$boundary"

    if ($response.ok) {
        Write-Host "[Y] Documento enviado com sucesso!"
    } else {
        Write-Host "[X] Erro ao enviar: $($response.description)"
    }
} catch {
    Write-Error "Erro ao enviar o documento: $_"
}
