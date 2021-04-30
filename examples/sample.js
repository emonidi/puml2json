const PlantUmlToCode = require('../src');

const plantuml = PlantUmlToCode.fromFile('./examples/sample.puml');
plantuml.generate().then(out => out.print());
