Param(
    [Parameter(Mandatory=$True)]$Path,
    [Parameter(Mandatory=$True)]$OffsetMilliseconds
)

Function Main() {
    $text = Get-Content $path -Encoding UTF8

    $out = @()

    foreach ($line in $text) {
        if ($line -match '-->') {
            $out += Convert-TimeStampLine $line
        } else {
            $out += $line
        }
    }

    return $out

    $out | Out-Content newsub.srt -Encoding utf8
}

Function Convert-TimeStampLine {
    Param([Parameter(Mandatory=$True)][string]$TimestampLine)

    $stamp1 = [regex]::Match($TimestampLine, '^(.*) -->').Groups[1].Value
    $stamp2 = [regex]::Match($TimestampLine, '.*--> (.*)$').Groups[1].Value

    $newStamp1 = Convert-TimeStamp $stamp1
    $newStamp2 = Convert-TimeStamp $stamp2

    return "$newStamp1 --> $newStamp2"
}

Function Convert-TimeStamp($Timestamp) {
    $date = [DateTime]::ParseExact($Timestamp, 'HH:mm:ss,fff', [cultureinfo]::InvariantCulture)
    $date = $date.AddMilliseconds($Offset)
    return $date.ToString('HH:mm:ss,fff')
}

Main