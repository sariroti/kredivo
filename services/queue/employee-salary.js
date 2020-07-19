var bull = require('bull');

var employeeSalaryQueue = new bull('employee-salary', 'redis://127.0.0.1:6379');

employeeSalaryQueue.process(async(job) => {

});

employeeSalaryQueue.on('completed', async (job, result) => {

});


module.exports = {
    employeeSalaryQueue
}


