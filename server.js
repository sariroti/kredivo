const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
const PORT = 4000;

const db = require('./repositories/model/index');

const calendarRouter = require('./api/calendar');
const queueRouter = require('./api/queue');
const reportRouter = require('./api/report');


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
// app.use(function(req, res, next) {
//     res.header("Access-Control-Allow-Origin", "*");
//     res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
//     next();
//   });

var corsOptions = {
    origin: true,
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'true'
};

app.use(cors(corsOptions));

app.use('/calendar', calendarRouter);
app.use('/queue', queueRouter);
app.use('/report', reportRouter);

app.get('/', (req, res) => {
    res.send("Welcome to kredivo test api");
})
app.listen(PORT, () => {
    console.log(`server running on port ${PORT}`);
    db.sequelize.sync();
   
})