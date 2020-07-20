const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();
const PORT = 4000;

const db = require('./repositories/model/index');

const queueRouter = require('./api/queue');
const reportRouter = require('./api/report');


app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var corsOptions = {
    origin: true,
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'true'
};

app.use(cors(corsOptions));

app.use('/queue', queueRouter);
app.use('/report', reportRouter);

app.get('/', (req, res) => {
    res.send("Welcome to kredivo test api");
})
app.listen(PORT, () => {
    console.log(`server running on port ${PORT}`);
    db.sequelize.sync();
   
})