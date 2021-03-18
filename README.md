# Cron

## Overview

4D Component which includes methods to manage daemons.

## Description

By Installing this component into your 4D project, several methods are added to your 4D project, that can be used to manage daemon processes.

## Requirement

4D v18R5 or above

Note: This component uses new "Class" function introduced in 4D v18R3. Please do not open it with 4D v18R2 and under.

## Install

This is a 4D component, so you should build this source as 4D component and place it in the "Components" folder of your project root.

## Usage

var $cs_o; $cron_o; $daemon_o : Object

$daemon_o:=New object
$daemon_o.name:="mydaemond"
$daemon_o.method:="DaemonMethodName"
$daemon_o.interval:="60"
$daemon_o.parameter:=New object("param1"; "value1")

$cs_o:=Import Cron
$cron_o:=$cs_o.Cron.new()
$cron_o.add($daemon_o).start()

// On Exit
$cs_o:=Import Cron
$cron_o:=$cs_o.new()
$cron_o.stop()

## License

Please refer to "LICENSE" file.

## Release Note

Initial release (2021-03-18)  
