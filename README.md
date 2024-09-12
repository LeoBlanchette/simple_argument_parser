# Simple ArgParser for gdscript, Godot 4.3+

Sometimes it can be useful to have in-game commands submitted through a chat 
interface or line-edit.

## Simple syntax examples:

This simple ArgParser is made for the following simple syntax:

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
Since it is a simple command, the dictionary is simple. 
Verify it is a given command like this:

```
if command.is_command("/print_index"):
	# Do all the things...
	print("Its definitely a print_index command. Run the print_index() function now.")
```

## Simple named argument command case...

You are testing a level and you wish to teleport around your level by typing in
coordinates. Assuming you've submitted the command via a line-edit, or something...

```
var command_string:String = "/teleport --p 5 20 -5.2"

# Be sure to verify if command_string.begins_with("/"): before parsing.

var command:ArgParser = ArgParser.new(command_string)

```

The arguments dictionary in the class now contains this data:
	
```
{
	"args": ["/teleport", "--p", "5", "20", "-5.2"],
	"1": "5",
	"2": "20",
	"command": "/teleport",
	"--p": ["5", "20", "-5.2"],
	"argument_string": "/teleport --p 5 20 -5.2",
}

```
However you do not have to access the dictionary directly. I'm just showing it 
here so you can see what is available to you.

To access the data:
	
```
if command.is_command("/teleport"):
	# this is the teleport command...
	pass

# Does it have the necessary --p argument? (in this case, --p is position)

if command.has_argument("--p"):
	# user has submitted the argument properly. We can grab the data.
	
	var coords:Array = command.get_argument("--p")
	
	# this will contain an array of strings you must convert to floats.
	
	# ["5", "20", "-5.2"]

```

### More complex uses...

So long as you stick to the syntax...

```
/some_command --a 1 2 3 --b this that other
```

...things should go well.

Here is a more complex example. For the modding features of my game, much of 
the things are spawned in by commands as well, though the text commands are 
generated in gdscript and fed into my command system.

So this command:
	
```
/spawn structures 8 --p 1.82052993774414 0.00000023841858 0.74802494049072 --r -0.00000085377366 0.00001195283585 0
```

... is easily parsed by the parser. In this case, the command is saying:

***Spawn a structure of id=8 at position [values] and rotation [values]***

This will be parsed into the dictionary as follows:
	
```
{
	"args": [
		"/spawn",
		"structures",
		"8",
		"--p",
		"1.82052993774414",
		"0.00000023841858",
		"0.74802494049072",
		"--r",
		"-0.00000085377366",
		"0.00001195283585",
		"0",
	],
	"1": "structures",
	"2": "8",
	"3": "1.82052993774414",
	"4": "0.00000023841858",
	"5": "0.74802494049072",
	"6": "0.00001195283585",
	"7": "0",
	"command": "/spawn",
	"--p": ["1.82052993774414", "0.00000023841858", "0.74802494049072"],
	"--r": ["-0.00000085377366", "0.00001195283585", "0"],
	"argument_string": "/spawn structures 8 --p 1.82052993774414 0.00000023841858 0.74802494049072 --r -0.00000085377366 0.00001195283585 0",
}

```
Then access accordingly:
	
```
# Get the second argument, which is "structures" (the first is the command itself)
var item_type:String=command.get_second_argument()

# Get the third argument, which is the id (will have to convert to int, btw, cuz string now)
var item_id:String=command.get_third_argument()

# The position will be an array of 3 numbers submitted by user, string form...
var pos:Array[String]=command.get_argument("--p")

# And likewise the rotation...
var rot:Array[String]=command.get_argument("--r")

# Now work with the data accordingly, being sure to convert the strings to floats.
```
### Or simple again...

But you may not always need the --<command> syntax. Maybe you just wish to feed in
arbitrary words and your function will figure out the rest.

```
/give_little_pink_houses Jack Diane Me
```
Becomes:
```
{
	"args": ["/give_little_pink_houses", "Jack", "Diane", "Me"],
	"1": "Jack",
	"2": "Diane",
	"3": "Me",
	"command": "/give_little_pink_houses",
	"argument_string": "/give_little_pink_houses Jack Diane Me",
}

# Simply use the simple quick-shots for this one...

var first_person:String = command.get_argument("1", "Me)

var second_person:String = command.get_argument("2")

var third_person:String = command.get_argument("3")


```
Notice in first_person above, I fed in a default argument. 

These will return null if no argument is found at given position unless you 
provide a default.

### Conclusion.
Feel free to check out the main script arg_parser.gd to see how it works.
This is a very simple syntax meant for this very simple purpose of in-game 
text commands or dev use.

If you have any improvements to add, I would love to see them.

Thank you.
