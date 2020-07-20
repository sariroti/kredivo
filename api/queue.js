const express = require('express');
const router = express.Router();

const db = require('../repositories/model/index');

const preProcessorQueue = require('../services/queue/pre-processor').preProcessorQueue;
const  employeeDailyAbsenceLeaveQueue = require('../services/queue/employee-daily-absence').employeeDailyAbsenceQueue;
const employeeLeaveQueue = require('../services/queue/employee-leave').employeeLeaveQueue;
const employeeSalaryQueue = require('../services/queue/employee-salary').employeeSalaryQueue;

router.get('/', async(req, res) => {
    
    var queryTotalEmployee = await db.sequelize.query(`select count(emp_no) as total_employee, 
                                                        (
                                                            select emp_no from employees
                                                            order by emp_no desc
                                                            limit 1
                                                        ) as emp_no_end,
                                                        (
                                                            select emp_no from employees
                                                            order by emp_no asc
                                                            limit 1
                                                        ) as emp_no_start
                                                        from employees`);

 
    
    var totalEmployee = queryTotalEmployee[0][0].total_employee;
    var empNoStart = queryTotalEmployee[0][0].emp_no_start;
    var empNoEnd = queryTotalEmployee[0][0].emp_no_end;
    var empNoEndLeave = empNoEnd / 2; // populate half of employee for leave data

    var empNoStartSalary = empNoStart;

    while(empNoStart < empNoEnd){
        var newEmpNoEnd = empNoStart + 1000;
        newEmpNoEnd = newEmpNoEnd > empNoEnd ? empNoEnd : newEmpNoEnd;
        await employeeDailyAbsenceLeaveQueue.add({empNoStart,newEmpNoEnd})

        if(empNoStart < empNoEndLeave){
            await employeeLeaveQueue.add({empNoStart, newEmpNoEnd});
        }

        await employeeSalaryQueue.add({empNoStart, newEmpNoEnd}, { delay:10000 });

        empNoStart = newEmpNoEnd + 1;

    }

    res.send('Queue started');
})

module.exports = router;