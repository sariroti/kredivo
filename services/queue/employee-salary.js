var bull = require('bull');
const {QUEUE_EMPLOYEE_SALARY} = require('../constants/index'); 

var employeeSalaryQueue = new bull(QUEUE_EMPLOYEE_SALARY, 'redis://127.0.0.1:6379');
const db = require('../../repositories/model/index');

employeeSalaryQueue.process(async(job) => {
    console.log(job.data);

    return await db.sequelize.query(`CALL sp_employee_salary_adjustment(${job.data.empNoStartSalary},${job.data.newEmpNoEnd})`);
});

employeeSalaryQueue.on('completed', async (job, result) => {
    console.log(`Employee salary job completed => ${job.id}`);
    console.log(result);
});


module.exports = {
    employeeSalaryQueue
}


