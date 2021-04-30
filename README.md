[![JavaScript Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://standardjs.com)
[![License badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io) 


## PlantUML json generator (puml2json)

a command line utility that convert PlantUML -text file that represent component UML diagram to JSON.
This fork is based on [puml2code]() .

puml2json supports only a subset of the PlantUML language.

### Installation

Global installation brings `puml2json` command to PATH
```bash
$ npm i -g puml2json
```

Development installation
```bash
$ git clone https://github.com/robbito/puml2json.git
$ npm i
$ bin/puml2json -h
```

Running tests
```bash
$ npm test
```

### Supported features
* puml parser engine: [pegjs](http://pegjs.org)

**NOTE:**

The parser only supports a small subset of PlantUML features. Have a look at the examples folder.

### Problems?

* If `puml2json` causes error like:
    ```
    Error: line: 21 column: 3: SyntaxError: Expected "'", "--", "..", "__", "abstract ", 
    "class ", "hide empty members", "interface ", "namespace ", "note ", "skinparam", "title ",
    [ \t], [#], [+], [A-Za-z_], [\-], [\n], [\r\n], [^ ,\n\r\t(){}], or [}] but "{" found.
    ```
    it's most probably because [PEG.js based grammar](src/parser/plantuml.pegjs) does not have support 
    for plantuml format you have in input file. 
    
    **What should I do?**
    
    Please [raise ticket](https://github.com/robbito/puml2json/issues/new?template=grammar.md) with example plantuml file that does not work

* generated json does not look like you expected
    
    **What should I do?**
    
    Please [raise ticket](https://github.com/robbito/puml2json/issues/new?template=output.md) with example plantuml file and generated json
    with some description how it should look like.


**NOTE** If you are able to create PR that solves your issue it would be even more welcome.

### Usage

```
$ puml2json -h
Usage: puml2json [options]

Options:
  -V, --version       output the version number
  -i, --input [file]  input .puml file, or "stdin"
  -o, --out [path]    Output path. When not given output is printed to console.
  -h, --help          output usage information

Examples:
  $ puml2json -i input.puml
  $ puml2json -h
Use DEBUG=puml2json env variable to get traces. Example:
  $ DEBUG=puml2json puml2json -i input.puml
```

### LICENSE:
[MIT](LICENSE)
