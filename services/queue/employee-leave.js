var bull = require('bull');

var employeeLeaveQueue = new bull('employee-leave', 'redis://127.0.0.1:6379');
const db = require('../../repositories/model/index');

employeeLeaveQueue.process(async(job) => {
    console.log(job.data);

    return await db.sequelize.query(`CALL sp_employee_leave_generator(${job.data.empNoStart},${job.data.newEmpNoEnd})`);
  
});

employeeLeaveQueue.on('completed', async (job, result) => {
    console.log(`Employee leave job completed => ${job.id}`);
    console.log(result);
});


module.exports = {
    employeeLeaveQueue
}


