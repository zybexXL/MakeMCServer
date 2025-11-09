# <img width=64 src="https://github.com/zybexXL/MakeMCServer/blob/main/JRiver-Red.png"> MakeMCServer
Script to setup an MC Library Server instance

Forum post: https://yabb.jriver.com/interact/index.php/topic,142498.0.html

# Running multiple MC library servers on the same Windows PC
This batch script adds a new MC Library Server instance. It creates a new [hidden] user account and adds a desktop shortcut to start the new server.

These are the requirements to run multiple instances - **the script automates this for you**:
- each MC instance must run under a different user account so that it has its own settings in the registry and its own files under the account profile folder (though they can all show up on the same desktop)
- "Allow multiple instances" option must be checked on all instances
- each instance must be using a different TCP port (52199 is the default for the main instance)

# Instructions:
- run the script as Administrator
- enter the instance number you wish to create (press ENTER to accept "2" as default)
- check if the displayed username/password/MCport/MCVersion (autodetected) are correct - **note the password written here!**
- press ENTER to confirm 
- the script will ask you to type the password once - **you must write the same password as given above!**
- the instance and desktop shortcut will now be created

That's it. 

A new shortcut should show up on your desktop to start the instance; it will start as a brand new MC without any library, so you'll need to restore a backup or configure it from scratch. You'll also need to [re]enable the MediaNetwork to actually start serving the library - it will generate a new Access Key for that library. I recommend you put all libraries on a folder such as C:\MCLibraries and adjust the folder permissions so that all user accounts can read/write to it.


# Desktop Icon
The desktop icon is a .bat script, not a shortcut. If you prefer you can move the .bat somewhere else and create a real shortcut to it on the desktop - I attached a red MC icon I made for this purpose.

The script also places a shortcut under the Startup menu so that the new instance starts automatically after logon.

# Removing an instance
To remove an instance:

- close the server instance (including system tray icon)
- delete the account: `net user /delete mcuser2`
- delete the startup shortcut: `del "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\start mc2.bat"`
- delete the desktop shortcut: `del "%userprofile%\desktop\start mc2.bat"`
- optional: delete the user profile folder (careful if the library is inside!): `del /q /s c:\users\mcuser2`
