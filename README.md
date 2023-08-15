# GOOP
###### Gage's Object Oriented Programming
An OOP library for lua that enables all of the oop features you'd want - Along with type checked parameters for instantiation.

## Install
Place the `/GOOP` anywhere you'd like in your directory and require it.
```Lua
local Goop = require("libs.GOOP")
```

## Quick Start
Goop's only function is to define a class.  
For this example lets make a `Shape` class that has a color and position. 
```Lua
local Goop = require("libs.GOOP")
local Shape = Goop.Class({
  static = {
    color = {1,1,1}
  },
  dynamic = {
    position = {x = 50, y = 50}
  }
})
```
We can instantiate this class by calling it's name as a function:
```Lua
local myNewShape = Shape()
```

Next lets extend from this class and make a rectangle sub-class.
```Lua
local Rectangle = Goop.Class({
  extends = Shape,
  parameters = {
    {"dimensions", "table"}
  }
})
```
Here we've specified that we want our new `Rectangle` class to inherit from, or extend the `Shape` class.  
And, that when instantiated, we must provide a `dimensions` paremeter with the type `table`.
```Lua
Rectangle() ---ERROR: Missing parameter dimensions
Rectangle({dimensions = 5}) ---ERROR: dimensions is wrong type. Expected 'table'. Received 'number'.
Rectangle({dimensions = {width = 50, height = 50})
```

## `Goop.Class`
The `Goop.Class` function takes one table as an argument with four optional values:
* `static`
* `dynamic`
* `parameters`
* `extends`

`static` and `dynamic` represent the state of the class. `dynamic` values will have brand new references created whenever the class is instantiated - While `static` values will always refer to the class definitions value.

`parameters` refers to a table of values you can pass to the class upon instantiation. When setting `parameters` in a class definition, it expects an array of tables describing the key and type of any parameters you want to be *necessary* when creating the class.  
Not providing these parameters, or providing one with the wrong type will result in an error.

```Lua
local Character = Goop.Class({
  parameters = {
    {"health", "number"},
    {"name", "string"}
  }
})

local newCharacter = Player({health = 1, name = "John"})
```
  
`extends` defines a class you want to "extend" from, or inherit from. Any required parameters from that class will also be required to instantiate the subclass you are defining.

```Lua
local Player = Goop.Class({
  extends = Character
})
local newPlayer = Player({name = "Timmy"}) ---ERROR: missing parameter 'health'
```

# Help
If you run into any issues feel free to get in touch with me on discord: @callgage  

Feel free to use this in any capacity.
