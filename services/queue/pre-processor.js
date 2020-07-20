const bull = require('bull');
const db = require('../../repositories/model/index');
const {QUEUE_PRE_PROCESSOR, SP_DATE_GENERATOR} = require('../constants/index'); 

var preProcessorQueue = new bull(QUEUE_PRE_PROCESSOR, process.env.REDIS_SERVER_URL);

preProcessorQueue.process(async(job) => {
    return await db.sequelize.query(`CALL ${SP_DATE_GENERATOR}();`);
});

preProcessorQueue.on('completed', async (job, result) => {
    console.log(`job completed => ${job.id}`);
    console.log(result);
});


module.exports = {
    preProcessorQueue
}


