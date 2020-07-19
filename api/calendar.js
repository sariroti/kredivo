const express = require('express');
const router = express.Router();
const preProcessorQueue = require('../services/queue/pre-processor').preProcessorQueue;

router.get('/', async(req, res) => {
  
    await preProcessorQueue.add();

    res.send('calendar created');
})

module.exports = router;