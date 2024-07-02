# Start-SimplePSScriptSleepCounter
Creates a progress bar to count down seconds.

## PARAMETERS
### PARAMETER CounterName
[string] Name/Title of the counter

### PARAMETER Seconds
[int] Time the counter runs in seconds. Minimum 10 seconds. 

### PARAMETER TimeSpan
[object] The time in an accemptable timespan format (timespan object, string, or int). String format: d.HH:mm:ss:ffff

### PARAMETER CounterInterval
[object] How often, in acceptable timespan format, the counter updates. Defaults to 1 second

## EXAMPLES
### EXAMPLE
Start-SimpleScriptSleepCounter -Seconds 30

### EXAMPLE
Start-SimpleScriptSleepCounter -Seconds 30 -CounterInterval 5

### EXAMPLE
Start-SimpleScriptSleepCounter -TimeSpan "0.00:00:30" -CounterInterval "0.00:00:02"
Creates a counter of 30 seconds that updates every 2 seconds. 

## NOTES
Created On: 08/11/2020
Version 2.0

CHANGE CONTROL
    v2.0 - Removed Milliseconds and the varied interval switches. Implemented TimeSpan support. 
## COPYRIGHT
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
