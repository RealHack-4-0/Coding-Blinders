const express = require('express');
const routes = express.Router();

const admin = require('./routes/admin');
const drug = require('./routes/drug');
const pharmacy = require('./routes/pharmacy');
const user = require('./routes/user');
const appointment = require('./routes/appointment');
const report = require('./routes/report');


routes.use('/admin', admin);
routes.use('/drug', drug);
routes.use('/pharmacy', pharmacy);
routes.use('/user', user);
routes.use('/appointment', appointment);
routes.use('/report', report);

module.exports = routes;