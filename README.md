# SolariumVR Examples

## Running Examples

To run examples you will need to install Dart and `solarium_tools`

To install `solarium_tools` run

`pub global activate solarium_tools`

#### Dependencies

Before running make sure to get the package dependencies.

`$ cd examples`
`$ pub get --packages-dir`

The option `--packages-dir` is currently needed so the dependencies are accessible on the web.
Using the default behavior the packages will not be accessible.

Note: If you are using Intellij Dart Plugin you can not use the built in pub get functionality. You must run the command in a terminal.


#### Run

To run examples serve run:

`$ solarium serve --path examples`

