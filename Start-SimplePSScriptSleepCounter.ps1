<#
.SYNOPSIS
    Creates a progress bar to count down seconds.

.DESCRIPTION 
    Creates a progress bar to count down seconds based on supplied counter information. 
    Intended for use within scripts to give real-time progress while simply waiting.
    Should replace Start-Sleep if sleep extends beyond more than a few seconds. 

.PARAMETER CounterName
    [string] Name/Title of the counter

.PARAMETER Seconds
    [int] Time the counter runs in seconds. Minimum 10 seconds. 

.PARAMETER TimeSpan
    [object] The time in an accemptable timespan format (timespan object, string, or int). String format: d.HH:mm:ss:ffff

.PARAMETER CounterInterval
    [object] How often, in acceptable timespan format, the counter updates. Defaults to 1 second

.EXAMPLE
    Start-SimpleScriptSleepCounter -Seconds 30

.EXAMPLE
    Start-SimpleScriptSleepCounter -Seconds 30 -CounterInterval 5

.EXAMPLE
    Start-SimpleScriptSleepCounter -TimeSpan "0.00:00:30" -CounterInterval "0.00:00:02"
    Creates a counter of 30 seconds that updates every 2 seconds. 

.NOTES
    Created On: 08/11/2020
    Version 2.0

    CHANGE CONTROL
        v2.0 - Removed Milliseconds and the varied interval switches. Implemented TimeSpan support. 
.COPYRIGHT
Copyright (c) ActiveDirectoryKC.NET. All Rights Reserved

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

The website "ActiveDirectoryKC.NET" or it's administrators, moderators, 
affiliates, or associates are not affilitated with Microsoft and no 
support or sustainability guarantee is provided. 
#>
function Start-SimpleScriptSleepCounter
{
    Param(
        [Parameter(Mandatory=$false)]
        [string]$CounterName = "Sleep Counter",

        [Parameter(Mandatory=$true,ParameterSetName="Seconds")]
        [object]$Seconds,

        [Parameter(Mandatory=$true,ParameterSetName="TimeSpan")]
        [object]$TimeSpan,

        [Parameter(Mandatory=$false)]
        [object]$CounterInterval = [timespan]::FromSeconds(1)
    )

    Begin
    {
        [TimeSpan]$CounterTimeSpan = [TimeSpan]::FromSeconds(0)
        [TimeSpan]$CounterTimeSpanInterval = [TimeSpan]::FromSeconds(0)
        [int]$Elapsed = 0;

        $ProgressId = Get-Random -Minimum 1000 -Maximum 9999 # Create a Random Progress Id. 

        if( $PSBoundParameters.ContainsKey("TimeSpan") )
        {
            if( $TimeSpan -is [int] )
            {
                $CounterTimeSpan = [timespan]::FromSeconds($TimeSpan)
            }
            else
            {
                Try
                {
                    $CounterTimeSpan = [TimeSpan]::Parse($TimeSpan) # If this errors, don't care to catch it. 
                }
                Catch
                {
                    Write-Error -Message "Only Int32, TimeSpan or String can be converted to TimeSpan objects - Exiting" -Category ArgumentException
                    throw $PSItem
                }
            }
        }
        else
        {
            $CounterTimeSpan = [TimeSpan]::FromSeconds($Seconds)
        }

        if( $CounterTimeSpan.TotalSeconds -lt 10 )
        {
            Write-Warning "Counters less than 10 seconds are not supported - defaulting to 10 seconds"
            $CounterTimeSpan = [TimeSpan]::FromSeconds(10)
        }

        if( $PSBoundParameters.ContainsKey("CounterInterval") -or $CounterInterval )
        {
            if( $CounterInterval -is [int] )
            {
                $CounterTimeSpanInterval = [timespan]::FromSeconds($CounterInterval)
            }
            else
            {
                Try
                {
                    $CounterTimeSpanInterval = [TimeSpan]::Parse($CounterInterval) # If this errors, don't care to catch it. 
                }
                Catch
                {
                    Write-Error -Message "Only Int32, TimeSpan or String can be converted to TimeSpan objects - Exiting" -Category ArgumentException
                    throw $PSItem
                }
            }
        }

        if( $CounterTimeSpanInterval -eq [timespan]::FromSeconds(0) )
        {
            $CounterTimeSpanInterval = [timespan]::FromSeconds(1)
        }
        elseif( $CounterTimeSpanInterval.TotalMilliseconds -lt 50 )
        {
            $CounterTimeSpanInterval = [timespan]::FromMilliseconds(50)
        }

    }

    Process
    {
        while( $Elapsed -le $CounterTimeSpan.TotalMilliseconds )
        {
            $StatusMessage = "$($Elapsed/1000) seconds have passed"

            if( $CounterTimeSpanInterval.TotalSeconds -gt 2 )
            {
                $StatusMessage += " - Next update in $($CounterTimeSpanInterval.TotalSeconds) seconds"
            }

            Write-Progress -id $ProgressId -Activity $CounterName -Status $StatusMessage -SecondsRemaining (($CounterTimeSpan.TotalMilliseconds - $Elapsed)/1000) -PercentComplete (($Elapsed / $CounterTimeSpan.TotalMilliseconds) * 100)
            Start-Sleep -Milliseconds $CounterTimeSpanInterval.TotalMilliseconds
            $Elapsed += $CounterTimeSpanInterval.TotalMilliseconds
        }
    }

    End
    {
        # This will kill the progress bar if it get's stuck for some reason.
        Write-Progress -id $ProgressId -Activity $CounterName -PercentComplete 100
    }
}