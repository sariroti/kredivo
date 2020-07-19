var bull = require('bull');

var employeeDailyAbsenceQueue = new bull('employee-daily-absence', 'redis://127.0.0.1:6379');

employeeDailyAbsenceQueue.process(async(job) => {

});

employeeDailyAbsenceQueue.on('completed', async (job, result) => {

});


module.exports = {
    employeeDailyAbsenceQueue
}


