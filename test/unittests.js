// native modules
const path = require('path');
// 3rd party modules
const chai = require('chai');
const { spy } = require('sinon');
const chaiAsPromised = require('chai-as-promised');


const { expect } = chai;
chai.use(chaiAsPromised);
// modules under test
const {PlantUmlToJson} = require('../src');


describe('pumlgen', () => {
  it('ok', () => {
    const puml = new PlantUmlToJson();
    expect(puml).is.ok;
    expect(PlantUmlToJson.fromFile).to.be.an('function');
    expect(PlantUmlToJson.fromString).to.be.an('function');
  });

  describe('from', () => {
    it('String with invalid parameter', () => {
      expect(() => PlantUmlToJson.fromString({})).to.throw();
    });
    it('String', async () => {
      const puml = PlantUmlToJson.fromString('@startuml\ncomponent Test\n@enduml\n');
      const output = await puml.generate();
      expect(output).to.be.ok;
    });
    it('File', async () => {
      const puml = PlantUmlToJson.fromFile(path.join(__dirname, './data/simple.puml'));
      const output = await puml.generate();
      expect(output).to.be.ok;
    });
    it('File not found', () => {
      expect(() => PlantUmlToJson.fromFile('not-exists.puml')).to.be.throw;
    });
  });
});
