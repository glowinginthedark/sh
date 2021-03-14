One of my hobbies is writing shell scripts and this repository contains some scripts that I've written to improve my workflow. 
Each item in the root directory is independent of the others.

## toggleBluetooth.sh
A script for ubuntu 20.04 that automatically connects (or disconnects if it was connected) to a bluetooth device such as a pair of headphones.

## html
A script that automates the creation and deletion of simple starter HTML projects. As a developer that likes experimenting with vanilla JS quite a bit,
I often want to create and destroy (ones that I don't need anymore) simple, isolated HTML projects. Here, I can experiment with new designs, animations, UI and
other things. However, everytime I have wanted to create a new isolated project I have had to go through a number of steps until I write my first line of JS and 
refresh the page (yes, I still do that). Here is a list of steps that I would do:
  * Navigate to my projects directory
  * Create a new folder for my new project
  * Open this directory in VS Code
  * Create a new index.html file
  * Find some starter HTML code and then copy and paste it (I guess this doesn't count as a step if you use a macro in the IDE)
  * Open the directory in an explorer window (to double click index.html and open it in the browser)

Well, what if you could do all of this with one command? That is what I wrote the script for. Now, all I have to do is type ```html.sh new <project_name>``` and in
an instant I can start writing my first line of JavaScript. The web page also automatically opens up in my browser so all I have to do is refresh when I am ready.
I also use a shell alias for my script so I can call it from anywhere. 

#### Usage
The only thing you need to start using this script is to specify a path to your projects directory (inside of which your new project directories will be created 
and destroyed) on line #3 of the script.

PS: If you do not have VS Code installed, or you use a different IDE, please make sure to comment out or change line #119. Same goes for your terminal of choice
(line #121).
