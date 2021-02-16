const path = require('path');
// 3rd party modules
const _ = require('lodash');
const program = require('commander');
// application modules
const Puml = require('./index');
const logger = require('./logger');
const Output = require('./Output');

const parseArgs = argv => program
  .version('0.1.0')
  .option('-i, --input [file]', 'input .puml file, or "stdin"')
  .option('-o, --out [path]', 'Output path. When not given output is printed to console.')
  .on('--help', () => {
    const print = console.log; // eslint-disable-line no-console
    print('');
    print('Examples:');
    print('  $ puml2json -i input.puml');
    print('  $ puml2json -h');
    print('Use DEBUG=puml2json env variable to get traces. Example:');
    print('  $ DEBUG=puml2json puml2json -i input.puml');
  })
  .parse(argv);

const fromStdin = () => {
  process.stdin.resume();
  process.stdin.setEncoding('utf8');
  return Promise.resolve(new Puml(process.stdin));
};
const fromFile = input => Promise.resolve(Puml.fromFile(input));

const getSource = args => {
  if (!args.input) {
    console.error('Error: input option is required'); // eslint-disable-line no-console
    args.help();
  }
  if (args.input !== 'stdin') {
    logger.debug(`Reading file: ${args.input}`); // eslint-disable-line no-console
    return fromFile(args.input);
  }
  console.log('Reading puml from stdin..'); // eslint-disable-line no-console
  return fromStdin();
};

const execute = async (argv = process.argv, printer = console.log) => { // eslint-disable-line no-console
  let args = { removeAllListeners: () => {} };
  try {
    args = parseArgs(argv);
    const puml = await getSource(args.opts());
    const json = await puml.generate();
    const files = {};
    files[`${path.parse(puml.file || 'puml').name}.json`] = JSON.stringify(json);
    const output = new Output(files, { logger });
    if (args.out) {
      await output.save(args.out);
    } else {
      output.print(printer);
    }
    logger.debug('ready');
    args.removeAllListeners();
    return 0;
  } catch (error) {
    logger.error(error);
    args.removeAllListeners();
    throw error;
  }
};
module.exports = execute;
module.exports.parseArgs = parseArgs;

if (require.main === module) {
  execute();
}
