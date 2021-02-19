const { Readable } = require('stream');
const { createReadStream } = require('fs');
// 3rd party modules
const Promise = require('bluebird');
const _ = require('lodash');
// application modules
const parser = require('./parser');
const dummyLogger = require('./logger');

const { SyntaxError } = parser;

class PlantUmlToJson {
  constructor(stream, file, { logger = dummyLogger } = {}) {
    this._stream = stream;
    this.file = file;
    this.logger = logger;
  }

  static fromString(str) {
    if (!_.isString(str)) {
      throw new TypeError('str should be an String');
    }
    const stream = new Readable();
    stream._read = () => {}; // redundant? see update below
    stream.push(str);
    stream.push(null);
    return new PlantUmlToJson(stream);
  }

  static fromFile(file) {
    return new PlantUmlToJson(createReadStream(file), file);
  }

  static async _readStream(stream) {
    const chunks = [];
    return new Promise((resolve, reject) => {
      stream.on('data', chunk => chunks.push(chunk));
      stream.on('error', reject);
      stream.on('end', () => resolve(Buffer.concat(chunks).toString('utf8')));
    });
  }

  async generate() {
    try {
      const str = await PlantUmlToJson._readStream(this._stream);
      return await parser(str);
    } catch (error) {
      if (error instanceof SyntaxError) {
        const str = `line: ${error.location.start.line} column: ${error.location.start.column}: ${error}`;
        this.logger.error(str);
        throw new Error(str);
      }
      this.logger.error(error);
      throw error;
    }
  }
}

module.exports.PlantUmlToJson = PlantUmlToJson;
