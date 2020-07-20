const bull = require('bull');
const {QUEUE_EMPLOYEE_LEAVE, SP_EMPLOYEE_LEAVE_GENERATOR} = require('../constants/index'); 
const db = require('../../repositories/model/index');

var employeeLeaveQueue = new bull(QUEUE_EMPLOYEE_LEAVE, process.env.REDIS_SERVER_URL);


employeeLeaveQueue.process(async(job) => {
    console.log(job.data);

    return await db.sequelize.query(`CALL ${SP_EMPLOYEE_LEAVE_GENERATOR}(${job.data.empNoStart},${job.data.newEmpNoEnd})`);
  
});

employeeLeaveQueue.on('completed', async (job, result) => {
    console.log(`Employee leave job completed => ${job.id}`);
    console.log(result);
});


module.exports = {
    employeeLeaveQueue
}


