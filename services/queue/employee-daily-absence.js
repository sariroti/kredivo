const bull = require('bull');
const {QUEUE_EMPLOYEE_DAILY_ABSENCE} = require('../constants/index'); 

var employeeDailyAbsenceQueue = new bull(QUEUE_EMPLOYEE_DAILY_ABSENCE, 'redis://127.0.0.1:6379');
const db = require('../../repositories/model/index');

employeeDailyAbsenceQueue.process(async(job) => {
    console.log(job.data);

    return await db.sequelize.query(`CALL sp_employee_absence_generator(${job.data.empNoStart},${job.data.newEmpNoEnd})`);
    
});

employeeDailyAbsenceQueue.on('completed', async (job, result) => {
    console.log(`Employee absence job completed => ${job.id}`);
    console.log(result);
});


module.exports = {
    employeeDailyAbsenceQueue
}


