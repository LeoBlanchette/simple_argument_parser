extends Node

## A simple argument parser in gdscript. And I do mean simple.
## It also includes some Helper functions for working with Vector3s 
## extracted from text.



class_name ArgParser

var arguments = {}

func _init(argument_string:String):		
	# Skip the first "/". Any "/" afterward will be considered part of an argument.
	var first_slash_skipped:bool = false
	var args = parse(argument_string)
	var args_named:Dictionary = {"args": args}
	var named_arg_elements:Array = []
	var populating_named_arg:bool = false
	
	# First step in parsing the argument array. Loop through general array
	# of arguments and push them to args_named array. This will populate
	# the simple arguments such as "/set_time day" where "day" is pushed 
	# to the array in order of where it was typed.
	var i:int = 1
	for arg:String in args:
		
		# Skip first slash (since often in-game commands start with "/").
		# After that, all slashes are part of arguments.
		if arg.begins_with("/") && not first_slash_skipped:
			first_slash_skipped = true
			continue
			
		# Skip any argument starting with "-" since -some_arg and --some_arg are 
		# set up differently class.
		if arg.begins_with("-"):
			continue
		args_named[str(i)] = arg
		i=i+1
	
	# Reset first slash skipped state for this next assessment of input.
	first_slash_skipped = false
	
	#get the named args. These are arguments such as -some_arg and --some_arg
	for arg:String in args:
		
		# Skip first slash (since often in-game commands start with "/").
		# After that, all slashes are part of arguments.
		if arg.begins_with("/") && not first_slash_skipped:
			first_slash_skipped = true
			args_named["command"] = arg
		
		# This next phase grabs the named arguments and adds sub arguments to them
		# until the next named argument is found.
		if arg.begins_with("--") && populating_named_arg:
			args_named[named_arg_elements[0]] = named_arg_elements.slice(1)
			named_arg_elements = []
			populating_named_arg = false
			
		if arg.begins_with("--") && !populating_named_arg:
			populating_named_arg = true
			named_arg_elements.append(arg)
			continue
			
		if populating_named_arg:
			named_arg_elements.append(arg)
	
	if named_arg_elements.size() > 0:
		args_named[named_arg_elements[0]] = named_arg_elements.slice(1)
	args_named["argument_string"] = argument_string
	arguments = args_named

## Initially parses the argument parts into a packed string array.
## This will be the general "args" dictionary to start.
func parse(command:String) -> PackedStringArray:
	var command_parsed = command.split(" ", false)	
	var command_dict:Dictionary = {}	
	command_dict["args"] = command_parsed
	return command_parsed

## Get a simple named argument such as one found in "/set_time day" where
## "set_time" will be index 0 and "day" will be index 1.
func get_argument(arg: String, default_value = null):
	if arguments.has(arg):
		return arguments[arg]
	else:
		return default_value

## Checks if an argument exists in the arguments set.
func has_argument(arg:String)->bool:
	if arguments.has(arg):
		return true
	return false

## Easy function to get the first argument. In a string such as 
## /eat fish salmon "/eat" will be returned.
func get_first_argument()->String:
	if arguments["args"].size() > 0:
		return arguments["args"][0]
	return ""

## Easy function to get the second argument. In a string such as 
## /eat fish salmon "fish" will be returned.
func get_second_argument()->String:
	if arguments["args"].size() > 1:
		return arguments["args"][1]
	return ""

## Easy function to get the third argument. In a string such as 
## /eat fish salmon "salmon" will be returned.
func get_third_argument()->String:
	if arguments["args"].size() > 2:
		return arguments["args"][2]
	return ""

## Gets the name of the command that was just submitted.
func get_command()->String:
	return arguments["command"]

## Creates a vector from an array of numbers. 
static func vector_from_array(l:Array)->Vector3:
	var v:Vector3 = Vector3.ZERO	
	if l.size() == 0:
		return v
	if l.size() >= 1:
		v.x=float(l[0])
	if l.size() >= 2:
		v.y=float(l[1])
	if l.size() >= 3:
		v.z=float(l[2])
	return v

## Creates an array from a vector.
static func array_from_vector(v:Vector3)->Array:
	return [v.x, v.y, v.z]

## Creates a string from a vector.
static func string_argument_from_vector(arg:String, v:Vector3):	
	var s:String = "{arg} {x} {y} {z}".format({"arg":arg, "x":v.x,"y":v.y, "z":v.z})
	return s

## For testing: Print the arguments Dictionary.
func print_arguments()-> void:
	print(arguments)
