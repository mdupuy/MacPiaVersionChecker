# Mac Pia Version Checker

I was tired of getting false positives from visualping.io to check if Private Internet Access's Mac client had updated so I wrote a simple bash function to get the version from PIA's web site and compare it to my version and download the website copy if they differ. 

I am not a bash guru. I assume there are far better ways to do each of the things that I've done and invite modifications. I'll improve this myself (i.e. figure out a gracefull shutdown and maybe add an internet connection check before doing anything) but this is the earliest version I wanted to share with other friends. We're all eagerly awaiting some bug fixes from the current version of PIA (v.55). 

To use this, simply copy and paste the function in to your ~/.bashrc file (if you use one)

Alternatively you could remove the function line and the last line and add
```sh
 #!/bin/bash
 ```
To the top of the file and make is a mac ".command" file with execute permissions (chmod 755 *.command) and double-click to execute it. 

# Dependencies
You need to have "wget" and "curl" installed. I think curl is part of OS X because it is in /usr/bin. You can install wget with http://brew.sh or you can uncomment the lines with "open" and delete the "wget" lines and your browser will download the file wherever your default is.
