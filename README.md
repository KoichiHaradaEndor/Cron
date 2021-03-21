# Cron

## Overview

4D Component which includes methods to manage daemons.

## Description

By Installing this component into your 4D project, one method is added to your 4D project, that can be used to manage daemon processes.

## Requirement

This component uses new "Class" function introduced in 4D v18R3. Please do not open it with 4D v18R2 and under.

Developed and tested with 4D v18R5.

## Install

This is a 4D component, so you should build this source as 4D component and place it in the "Components" folder of your project root.

## Usage
```
var $cs_o; $cron_o; $daemon_o : Object

$cs_o:=Import Cron

$daemon_o:=$cs_o.Daemon.new("mydaemond"; Formula(DaemonMethodName); 60; New object("param1"; "value1"))

$cron_o:=$cs_o.Cron.new()
$cron_o.add($daemon_o).start()

// On Exit
$cs_o:=Import Cron
$cron_o:=$cs_o.Cron.new()
$cron_o.stop()
```
## License

Please refer to "LICENSE" file.

## Release Note

Initial release (2021-03-18)

EXECUTE METHOD => Formula (2021-03-21)