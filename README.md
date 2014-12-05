# Scaffoldish

*Universal scaffolding super powa for everyone!*

[![Gem Version](https://badge.fury.io/rb/scaffoldish.svg)](http://badge.fury.io/rb/scaffoldish)


[![Build Status](https://travis-ci.org/debona/Scaffoldish.svg)](https://travis-ci.org/debona/Scaffoldish)
[![Coverage Status](https://coveralls.io/repos/debona/Scaffoldish/badge.png)](https://coveralls.io/r/debona/Scaffoldish)
[![Code Quality](https://codeclimate.com/github/debona/Scaffoldish.png)](https://codeclimate.com/github/debona/Scaffoldish)

Brings Rails-ish scaffolding super powa for every developpers, no matter they don't code with blessed RoR.

Current development status: Scaffoldish is still a **prototype**

That means your opinion is welcome and contributions will be appreciated.

## Install it

To install it, run `gem install scaffoldish` in your terminal to get the latest _stable_ version.

## Prepare your projects

Create a `./Scaffoldable` configuration file at your project root like that:

```ruby
require 'ostruct'

project_root = File.dirname(__FILE__) # Ensure your project root is where your Scaffoldable live
templates_root = File.join(project_root, 'templates') # Specify the dir in which you drop your templates

scaffold :Model do |name, attribute| # Create a scaffold that you will call to generate files

  # Prepare your data before to generate files
  data = OpenStruct.new()
  data.name = name = name.capitalize
  data.attribute = attribute = attribute.downcase

  # This will generate a file Model.java by executing the template Model.java.erb with data
  generate('Model.java.erb', "#{name}.java", data)

  # This will print console output asking to edit Controller.java by executing the template Controller.java.erb with data
  chunk('Controller.java.erb', 'Controller.java', data)
end
```

Create the two templates in `./templates/`:

`Model.java.erb`:
```java
public class <%= name %> {
	int <%= attribute %> = 0;
}
```

`Controller.java.erb`:
```java
	Add the following attribute:
	<%= name %> <%= name.downcase %> = new <%= name %>();
```

## Let's scaffold!

Open a terminal in your project and run: `cd your/project`

Then generate a new "Model" by running:

```shell
$ scaffoldish Model herp derp
```

It print that in your console, indicating what you should add to your `Controller.java`.

	Run Model:
	Edit Controller.java:
		Add the following attribute:
		Herp herp = new Herp();

It also generate the model `Herp`

`Herp.java`:
```java
public class Herp {
	int derp = 0;
}
```

## Licensing

See LICENSE.md
