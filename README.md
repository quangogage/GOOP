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

