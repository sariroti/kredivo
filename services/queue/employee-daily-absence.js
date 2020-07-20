const bull = require('bull');
const {QUEUE_EMPLOYEE_DAILY_ABSENCE, SP_EMPLOYEE_ABSENCE_GENERATOR} = require('../constants/index'); 
const db = require('../../repositories/model/index');

var employeeDailyAbsenceQueue = new bull(QUEUE_EMPLOYEE_DAILY_ABSENCE, 'redis://127.0.0.1:6379');


employeeDailyAbsenceQueue.process(async(job) => {
    console.log(job.data);

    return await db.sequelize.query(`CALL ${SP_EMPLOYEE_ABSENCE_GENERATOR}(${job.data.empNoStart},${job.data.newEmpNoEnd})`);
    
});

employeeDailyAbsenceQueue.on('completed', async (job, result) => {
    console.log(`Employee absence job completed => ${job.id}`);
    console.log(result);
});


module.exports = {
    employeeDailyAbsenceQueue
}


