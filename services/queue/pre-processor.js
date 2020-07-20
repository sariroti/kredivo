const bull = require('bull');
const db = require('../../repositories/model/index');
const {QUEUE_PRE_PROCESSOR} = require('../constants/index'); 

var preProcessorQueue = new bull(QUEUE_PRE_PROCESSOR, 'redis://127.0.0.1:6379');

preProcessorQueue.process(async(job) => {
    return await db.sequelize.query('CALL `employees`.`sp_date_generator`();');
});

preProcessorQueue.on('completed', async (job, result) => {
    console.log(`job completed => ${job.id}`);
    console.log(result);
});


module.exports = {
    preProcessorQueue
}


