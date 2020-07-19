var bull = require('bull');

var preProcessorQueue = new bull('pre-processor', 'redis://127.0.0.1:6379');

preProcessorQueue.process(async(job) => {

});

preProcessorQueue.on('completed', async (job, result) => {

});


module.exports = {
    preProcessorQueue
}


