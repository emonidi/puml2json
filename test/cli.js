// native modules
const { readFileSync } = require('fs');
// 3rd party modules
const chai = require('chai');
const { stub } = require('sinon');
const chaiAsPromised = require('chai-as-promised');
// module under test
const cli = require('../src/cli');
// list of files to use for test
const inputPumlList = ['./test/data/simple'];

const { expect } = chai;
chai.use(chaiAsPromised);

describe('cli', () => {
  let exit;
  beforeEach(() => {
    exit = stub(process, 'exit');
  });
  afterEach(() => {
    exit.restore();
  });
  it('version', async () => {
    process.exit.callsFake(() => {
      throw new Error('ok');
    });
    await cli(['node', 'puml2json', '-V']).catch(() => {});
    expect(process.exit.calledOnceWith(0)).to.be.true;
  });
  it('help', async () => {
    process.exit.callsFake(() => {
      throw new Error('ok');
    });
    await cli(['node', 'puml2json', '-h']).catch(() => {});
    expect(process.exit.calledOnceWith(0)).to.be.true;
  });
  it('invalid args', () => {
    process.exit.callsFake(() => {
      throw new Error('ok');
    });
    cli(['node', 'puml2json', '-a']);
    expect(process.exit.calledOnceWith(1)).to.be.true;
  });
  inputPumlList.forEach((input) => {
    describe(input, () => {
      it('json', async () => {
        let stdout = '';
        const printer = (data) => { stdout += `${data}\n`; };
        const shouldFile = `${input}.json`;
        const retcode = await cli(['node', 'puml2json', '-i', `${input}.puml`], printer);
        expect(stdout).to.be.equal(readFileSync(shouldFile).toString());
        expect(retcode).to.be.equal(0);
      });
    });
  });
});
