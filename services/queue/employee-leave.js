var bull = require('bull');

var employeeLeaveQueue = new bull('employee-leave', 'redis://127.0.0.1:6379');

employeeLeaveQueue.process(async(job) => {

});

employeeLeaveQueue.on('completed', async (job, result) => {

});


module.exports = {
    employeeLeaveQueue
}


