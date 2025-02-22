const bull = require('bull');
const {QUEUE_EMPLOYEE_SALARY, SP_EMPLOYEE_SALARY_ADJUSTMENT} = require('../constants/index'); 
const db = require('../../repositories/model/index');

var employeeSalaryQueue = new bull(QUEUE_EMPLOYEE_SALARY, process.env.REDIS_SERVER_URL);


employeeSalaryQueue.process(async(job) => {
    console.log(job.data);

    return await db.sequelize.query(`CALL ${SP_EMPLOYEE_SALARY_ADJUSTMENT}(${job.data.empNoStart},${job.data.newEmpNoEnd})`);
});

employeeSalaryQueue.on('completed', async (job, result) => {
    console.log(`Employee salary job completed => ${job.id}`);
    console.log(result);
});


module.exports = {
    employeeSalaryQueue
}


