I have two versions of the PowerShell script because I don't know how do you want to execute it.

1) First script imageUploader_permanent.ps1 - should be execute one time and never be closed or just execute in Background mode
This script depends on Sleep function, this is not the best solution of course, better to set up execution through Win Task Scheduler
Description: on execute it will start immediately and then sleep till next day '00:00:00'.
After that it will execute every day at '00:00:00' and then again sleep till next day.
It copies different images file in target directory depends on current day of the week.


2) Seconds script imageUploader_for_winScheduler.ps1 - should be add to Windows Task Scheduler
This script, actually, is similar to imageUploader_permanent.ps1, but without infinitive loop and Sleep function. 
It copies different images file in target directory depends on current day of the week too.
Steps how to do it:
1. In Windows 7, press the “Win” key, and search the start menu for “Task”.  You may need to turn on administrative tools if it isn’t already on.
2. Start the “Basic Task” wizard.
3. “Create a Basic Task” – Give your task a name (any) and description (optional).
4. “Trigger” – Set to Daily and set the time to “0:00:00”.
5. “Action” – Set to Start a Program.  Program/Script is “PowerShell.exe”.  Add argument for your script (“-ExecutionPolicy RemoteSigned -noprofile -noninteractive %PATH%\imageUploader_for_winScheduler.ps1”)
That's all, from now Scheduler will execute this script every day at '00:00:00'


