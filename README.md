# Simple ArgParser for gdscript, Godot 4.3+

Sometimes it can be useful to have in-game commands submitted through a chat 
interface or line-edit.

## Simple syntax examples:

This simple ArParser is made for the following simple syntax:

```
/kick <player>
```

...Where the first argument of player can be a name that a script will utilize
to kick the player.

or 

```
/teleport --p 2 20.5 3
```

...Where the ArgParser will grab the named argument --p with the array of 3 numbers
as strings.

or 

```
/equip 20 --pid 39493565
```

....Where you may equip item 20 to player who's peer_id is 39493565.

## Use Examples.

So you've submitted a text command through a line edit, or some other method. 
You wish to parse the command into arguments and values you can easily utilize.

Here are some examples:

### Simple one-shot command case...

I have a special index in game that holds all the IDs / Objects for items 
players have added in their mods. I want to print that index. Assuming I've 
created a function to list the items, I can initiate it through the text command 
as follows:

```
var command_string:String = "/print_index"

# Be sure to verify if command_string.begins_with("/"): before parsing.

var command:ArgParser = ArgParser.new(command_string)

```

This will contain the following dictionary:
	
```
{
	"args": ["/print_index"], 
	"command": "/print_index", 
	"argument_string": "/print_index"
}

```
