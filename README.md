# Linux Plugin Helper

Find and copy plugins files from multiple local folders
Uses the currently present files to find in specified locations

## Background

This was motivated by the failure of Oxide/.Net to correctly parse
Linux links to update file contents for plugin changes.  This used
to work great but died some time in 2024 if not earlier.
This is probably more of a .Net issue rather than an Oxide issue, but
the result is the same.

In fact, SOME links will cause not only plugin loading to fail, but
may also cause server startup to abort.

## Usage

Set PLUGIN_FOLDER to the target location of your Rust plugins.
  Include the trailing slash.

Set LOCS to a list of folders to search.  This must be surrounded by ().
  The list also includes search depth:

  LOCS=(/folder1:2 /folder2:1)

In my case, I have my ~/git folder and another folder where Windows
saves downloaded third-party plugins. ~/git has a folder per plugin, so
I search under each subfolder.  /data only has plugins at the top level:

LOCS=(~/git:2 /data:1)

depth:
  If 1, it will only search the specified folder.
  if 2, it will search one folder down within the specified folder.
  If 0, it will not find anything...

SET NOISY=0 to process files silently.  Set NOISY=1 for debugging.
SET CRON=1 to allow messages to be sent to cron email to note changes.

In my case, I added the following to my crontab to update between 5am and 8pm every minute;
* 5-20 * * * /home/remod/plugins.sh

SET COMMIT=1 to actually perform the file copies

SET CP to something like cp -a or rsync -a.
SET DIFF to a proper diff command to detect changes, e.g. diff -aurb.

## Thoughts

As a user of a Windows desktop and a Linux file server at home, I typically work with Visual Studio and
save my plugins directly to a per-plugin git folder located on the Linux server.  My dev Rust server runs
on Linux, and I had plugins linked from the git folders into its plugin folder.  I miss the days when
I could update a linked file and have Oxide re-read it correctly on the fly.

I suppose you could also just commit the plugins you want to always have on your server to a git repo.
At that point, the script would be reduced to 'git pull'
Ironically, this might not work so well for a developer working with a Linux based Rust server.
If you are going to the trouble of committing to a repo and pulling again, you may as well copy the file manually.
I suppose you could use cron to update the changed files every minute, which would sort of simulate the
expected behavior with linked files.

This is not a problem for Windows Rust servers.

Actually copying the files as we do here definitely triggers Oxide properly, so ymmv.

No AI was used in the creation of this script.  However, Google was used.

