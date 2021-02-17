// native modules
const path = require('path');
// 3rd party modules
const chai = require('chai');
const { spy } = require('sinon');
const chaiAsPromised = require('chai-as-promised');


const { expect } = chai;
chai.use(chaiAsPromised);
// modules under test
const Puml = require('../src');


describe('pumlgen', () => {
  it('ok', () => {
    const puml = new Puml();
    expect(puml).is.ok;
    expect(Puml.fromFile).to.be.an('function');
    expect(Puml.fromString).to.be.an('function');
  });

  describe('from', () => {
    it('String with invalid parameter', () => {
      expect(() => Puml.fromString({})).to.throw();
    });
    it('String', async () => {
      const puml = Puml.fromString('@startuml\ncomponent Test\n@enduml\n');
      const output = await puml.generate();
      expect(output).to.be.ok;
    });
    it('File', async () => {
      const puml = Puml.fromFile(path.join(__dirname, './data/simple.puml'));
      const output = await puml.generate();
      expect(output).to.be.ok;
    });
    it('File not found', () => {
      expect(() => Puml.fromFile('not-exists.puml')).to.be.throw;
    });
  });
});
