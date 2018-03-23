# Getting started with PowerShell

<#####  This is a comment Block!

Before we get started we need to make sure that we can effectively use the Help

So we need to open an elevated PowerShell Session and run Update-Help -Force

Start Powershell.exe
######>

#region Demos

#region Demo 1 - Help, Members, Properties and Simple Pipelining
  
  # I suggest to always start with a wildcard Get-Help search like below
Get-Help *Date*

  # Get the basic Help for the Get-Date Cmdlet
Get-Help Get-Date

  # Get the examples from the help for the Get-Date Cmdlet
Get-Help Get-Date -Examples

  # Shows us the default metadata for this Command type in PowerShell
Get-Command Get-Date 

  # Get the properties of the Get-Date Cmdlet as returned by the Get-Command Cmdlet
Get-Command Get-Date | Select-Object *

  # Gets all the Members of the Get-Date Cmdlet as returned by the Get-Command Cmdlet - This includes all Properties and Methods
Get-Command Get-Date | Get-Member

Get-Date | Get-Member -MemberType Methods
Get-Date | Get-Member -MemberType Properties

  # Gets all the Members of the Get-Date Cmdlet as returned by the Get-Command Cmdlet and then Groups them by their MemberType
Get-Date | Get-Member | Group-Object MemberType

  # Example Property of the object returned by Get-Date

(Get-Date).DayOfWeek
Get-Date | Select-Object -ExpandProperty DayOfWeek

Measure-Command { (Get-Date).DayOfWeek } # Typically quicker as not passing the whole object down the Pipeline

Measure-Command { Get-Date | Select-Object -ExpandProperty DayOfWeek }

  # Example of a Method of the object returned by Get-Date
Get-Date | Get-Member -MemberType Method

    
  # by doing this we can see how this method should be called
(Get-Date).AddDays


(Get-Date).AddDays(1)

(Get-Date).AddDays(-1)


#endregion Demo1 - Help, Members, Properties and Simple Pipelining

#region Demo 2 - Variables and the underlying Objects and Aliases


    # Variables

Get-Variable
Get-ChildItem Variable:\        

     
 #  There are 2 ways to create / amend a variable's value without an existing object

  # Way 1
Set-Variable 'Im a variable' -Value "Hi I'm A Variable"
${Im a variable} = "Hi I'm A Variable","Hi I'm one too"


 # Way 2
${Hello World} = 'Hello World' 
${Hello World}

# The Better more frequently used way as _ is an accepted character in a variable name where as - is not an accepted character

$Hello_World = 'Hello World'
$Hello-World = 'Hello World' # See how this has a Squiggly Red line underneath it

$Hello_World.GetType() # Notice how this is of String type and has a Base Object of System.Object


Set-Variable New_object -Value (New-Object PSCustomObject)

$New_object2 = New-Object PSCustomObject

$New_object3 = [PSCustomObject]::new() # PowerShell v5 +

$New_object.GetType()

$New_object2.GetType()

$New_object3.GetType()

Add-Member -InputObject $New_object -MemberType NoteProperty -Name CurrentDate -Value (Get-Date -Format dd/MM/yyyy)

Add-Member -InputObject $New_object -MemberType NoteProperty -Name Test2 -Value $Hello_World
#endregion Demo 2 - Objects

#region Demo 3 - Command types overview

Get-Command -CommandType Alias

Get-Alias

Get-Alias cd,dir,ls

(Get-Command -CommandType Alias).Count

(Get-Alias).Count

Get-Command -CommandType Function

(Get-Command -CommandType Function).Count

(Get-Command -CommandType Cmdlet).Count

# Simple Function
function Test-Mypath {
Write-Verbose 'Testing the current path exists'
Test-Path (Get-Location)
}

# Advanced Function 
function Test-MyBetterpath {
[Cmdletbinding()]
param()
Write-Verbose 'Testing the current path exists'
Test-Path (Get-Location)
}

# Advanced Function 
function Test-MyOtherpath {
[Cmdletbinding()]
param(
    
    [Paramater(Mandatory,
               ValueFromPipelineByPropertyName,
               ValueFromPipeline,
               Position=0)]
    [String]$path

)
Write-Verbose 'Testing the current path exists'
Test-Path $path 
}
  
#endregion Demo 3

#region Demo 4 Modules

Get-ChildItem GitHub:\kilasuit\PoshFunctions\Modules\Check-HaveIBeenPwndStatus -Filter *.ps*1 | foreach { psedit $_.FullName}

Get-ChildItem GitHub:\kilasuit\SPCSPS -Filter SP*.ps*1 | ForEach-Object { psEdit $_.FullName }

Get-Module

Get-Module -ListAvailable 

$env:PSModulePath

$env:PSModulePath.Split(';')

#endregion Demo 3