const Readable = require('stream').Readable;
    
class StreamReadable extends Readable {
  constructor(options) {
    super(options);
  }

  
  _read(chunk, encoding, callback) {
    console.log(chunk);
  }

}

module.exports = StreamReadable;