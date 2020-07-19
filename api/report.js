const express = require('express');
const router = express.Router();

const db = require('../repositories/model/index');

router.get('/avg-salary-title', async(req, res) => {
    
    var result = await  db.sequelize.query(`CALL sp_employee_avg_salary_title()`);

    res.send(result);
})

router.get('/avg-age', async(req, res) => {
    
    var result = await  db.sequelize.query(`CALL sp_employee_age_avg()`);

    res.send(result);
})
module.exports = router;