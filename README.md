# esrm

A simple command line Elden Ring save manager for your bourne again shell.

## Usage

Clone the repo or get only the `ersm.sh` from [here](https://raw.githubusercontent.com/jkmcnk/ersm/refs/heads/main/ersm.sh) and run it with no arguments to get help:

```
$ ./ersm.sh
esrm.sh <command> <args>

where command is one of

scan: attempts to find the current elden ring save on your system
configure <path-to-your-save-game>: configures your elden ring current save location
list [<category>]: lists stored elden ring saves, in the named category if given
store <category> <name>: stores current elden ring save under the given category and name
describe <category> <name>: edits the description of the save if needed
restore <category> <name>: restores the given save to elden ring
remove <category> <name>: removes the given save

as an example, consider quitting out and storing your save before a boss fight with

  esrm.sh store test i-will-probably-fuck-up-now

return to game, fuck up the boss fight, quit out, restore with

  esrm.sh restore test i-will-probably-fuck-up-now

then try again, fail again, fail better.
```

If you don't want to search for your Elden Ring save location yourself, you can try to scan your system. It scans the common steam folder. Your mileage might vary.

```
# ./ersm.sh scan
/home/xyz/.steam/steam/steamapps/compatdata/1245620/pfx/dosdevices/c:/users/steamuser/AppData/Roaming/EldenRing/76561198054192120/ER0000.sl2
/home/xyz/.steam/steam/steamapps/compatdata/1245620/pfx/dosdevices/c:/users/steamuser/Application Data/EldenRing/76561198054192120/ER0000.sl2
/home/xyz/.steam/steam/steamapps/compatdata/1245620/pfx/drive_c/users/steamuser/AppData/Roaming/EldenRing/76561198054192120/ER0000.sl2
/home/xyz/.steam/steam/steamapps/compatdata/1245620/pfx/drive_c/users/steamuser/Application Data/EldenRing/76561198054192120/ER0000.sl2
```

Now configure the path to the save game. Quote the path, it will commonly contains spaces.

```
# ./ersm.sh configure '/home/xyz/.steam/steam/steamapps/compatdata/1245620/pfx/drive_c/users/steamuser/Application Data/EldenRing/76561198054192120/ER0000.sl2'
```
https://raw.githubusercontent.com/jkmcnk/ersm/refs/heads/main/ersm.sh
And you're ready to go. Play some Elden Ring. Get somewhere. Store your save.

You should quit out before you do. You don't want the game writing to your save while copying it.

```
# ./ersm.sh store nohit setup-3-dts
current save is now safely stored
```

Continue playing. Inevitably fuck up. Restore the previously saved game.

Again, you should quit out before you do, otherwise the restore will be in vain.

```
# ./ersm.sh restore nohit setup-3-dts
restored your current save
```

That's it. Go work on your runs.
