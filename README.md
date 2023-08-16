# GOOP
###### Gage's Object Oriented Programming
An OOP library for lua that enables all of the oop features you'd want - Along with optional type checked arguments for instantiation.

## Install
Place the `/GOOP` anywhere you'd like in your directory and require it.
```Lua
local Goop = require("libs.GOOP")
```

## Quick Start
Goop's only function is to define a class.  
For this example lets make a `Person` class.

```Lua
local Person = Goop.Class({
    static = {
        species = "Homo sapiens"
    },
    dynamic = {
        name = "",
        age = 0
    },
    arguments = { "name", "age" }
})

local bob = Person("Bob") -- Missing arguments!
local bob = Person("Bob", 26) -- All good.
```

In order to inherit from this class, all we have to do is define the `extends` value.

```Lua
local Bob = Goop.Class({
  extends = Person,
  dynamic = {
    occupation = "construction",
    name = "Bob",
    age = 26
  }
})
```

## Type-Checking
Type checking arguments can be done easily, and at an individual level. All you have to do is define the argument as a table containing two strings - One for the string key, and one for the expected type.
```Lua
local Bob = Goop.Class({
  extends = Person,
  dynamic = {
    occupation = "construction",
    name = "Bob",
    age = 26
  },
  arguments = {
    {"age", "number"}, -- MUST be a number
    {"height", "number"}, -- MUST be a number
    "weight" -- Will not be type checked.
  }
})

local bobOne = Bob(26, "170cm", "60kg") -- Invalid type arg #2 - Expected number. Received string.
local bobTwo = Bob(26, 170, "60kg") -- All good
local bobTwo = Bob(26, 170, 60) -- Also good.
```

## Advanced class configuration
The `Goop.Class` function has 5 optional values.
* `extends`
* `dynamic`
* `static`
* `arguments`
* `parameters`

### `dynamic` and `static`
These refer to the state of the class. `dynamic` values will be deep copied to new instances of the class when created, while `static` values will only be shallow copied once upon definition of the class.  
This allows for better optimization - Less tables will be created over-all whenever you instantiate a new class.  
###### If optimization isn't an issue, feel free to just use dynamic!

## Parameters
This is a pretty niche feature of GOOP, and if you don't want to add any more confusion from something that most likely won't be relevant to you: I suggest you stop reading and get to goopin™.  
  
Parameters are an alternative to arguments. Rather than providing list of arguments when instantiating a class - You provide one: a table, with key-pair values representing the state of the instance.  
This allows for two things: More explicit argument definitions, and the ability to easily add custom state to the class within the instantiation function.

```Lua
local Bob = Goop.Class({
  extends = Person,
  dynamic = {
    occupation = "construction",
    name = "Bob",
    age = 26
  },

  -- Defining parameters
  parameters = {
    "age",
    "height",
    "weight"
  }
})

local bobOne = Bob({age = 26, height = "170cm", weight = "60kg", eyeColor = "blue", hairColor = "black"})
```

You are also able to type-check parameters the same way you would arguments.

```Lua
parameters = {
  {"age", "number"}, -- MUST be a number
  {"height", "number"}, -- MUST be a number
  "weight" -- Will not be type checked.
})
local bobOne = Bob({age = 26, height = "170cm", weight = "60kg") -- ERROR: Invalid parameter type "height". Expected "number", received "string". 
```

# Help
If you run into any issues feel free to get in touch with me on discord: @callgage  

Feel free to use this in any capacity.
