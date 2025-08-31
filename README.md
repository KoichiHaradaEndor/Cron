# Cron

## Overview

4D Component which includes methods to manage daemons.

## Description

By Installing this component into your 4D project, one method is added to your 4D project, that can be used to import Cron component's class store.

[Import Cron](src/Documentation/Methods/ImportCron.md)

After you import the class store, you can instantiate Cron and Daemon classes.

Or the component publishes `cs.Cron` class store, so you can write:

```4d
var $cron_o : cs.Cron.Cron
$cron_o:=cs.Cron.Cron.me

var $daemon_o : cs.Cron.Daemon
$daemon_o:=cs.Cron.Daemon.new("daemonNamed"; Formula(method); "every 1 hour")
```

[Cron Class](src/Documentation/Classes/Cron.md)

[Daemon Class](src/Documentation/Classes/Daemon.md)

## Requirement

This component uses new "Class" function introduced in 4D v18R3.
This component uses new "var" variable declaration syntax introduced in v18R5.
This component uses new shared single class introduced in v20R5.

Developed and tested with 4D v20R7.

## Install

This is a 4D component, so you should build this source as 4D component and place it in the "Components" folder of your project root.

## License

Please refer to "LICENSE" file.

## Release Note

Now Cron class is shared singleton class (2025-08-31)
cs.Cron namespace (2025-08-31)
EXECUTE METHOD => Formula (2021-03-21)
Initial release (2021-03-18)
