const express = require('express');
const user = express.Router();
const UserModel = require('../model/user');
const AppointmentModel = require('../model/appointment');
const password = require('../services/password');
const { generateToken } = require("../utills/generatetoken");

user.get('/', async (req, res) => {
    res.status(200).json({ msg: 'user' });
});

// get test
user.get('/test', async (req, res) => {
    // console.log(req.body);
    res.status(200).json({ msg: 'user test', data: req.body });
});

user.post('/create', async (req, res) => {

    try {
        const data = await UserModel.User.find({ email: req.body.email });

        if (data.length > 0) {
            console.log(data);

            res.status(900).json({ message: 'Already have an account!' });
            return;
        }

        password.cryptPassword(req.body.password, async function (err, hash) {

            const data = new UserModel.User({
                name: req.body.name,
                email: req.body.email,
                password: hash,
                role: 'patient',
            });

            // check if user created successfully
            // const dataToSave = await data.save((err, data) => {
            //     if (err) {
            //         res.status(400).json({ message: err.message });
            //         return;
            //     }
            // });
            const dataToSave = await data.save();

            const patient = new UserModel.Patient({
                userUid: data.id,
                gender: req.body.gender,
                address: req.body.address,
                telephone: req.body.telephone,
                birthday: req.body.birthday,
            });

            console.log(dataToSave)

            patient.save((err, data) => {
                if (err) {
                    UserModel.User.deleteOne({ _id: dataToSave.id }, (err) => { });

                    res.status(400).json({ message: err.message });
                    return;
                }

                res.status(200).json({ uid: dataToSave.id });
            });
        });
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }

});

user.post('/login', async (req, res) => {
    try {
        const data = await UserModel.User.find({ email: req.body.email });

        console.log(data);

        if (data.length === 0) {
            res.status(401).json({ message: 'Login failed!' });
            return;
        }

        password.comparePassword(req.body.password, data[0]['password'], async function (err, isPasswordMatch) {

            if (!isPasswordMatch) {
                res.status(401).json({ message: 'Login failed!' });
                return;
            }

            const token = await generateToken(data[0]['id'], data[0]['role']);
            res.status(200).json({ uid: data[0]['id'], token: token, role: data[0]['role'] });
        });
    }
    catch (error) {
        res.status(500).json({ message: error.message })
    }
});


// get one user
user.get('/:id', async (req, res) => {
    try {
        const data = await UserModel.User.find({ _id: req.params.id });

        if (data.length === 0) {
            res.status(400).json({ message: 'User not found' });
            return;
        }

        const users = await UserModel.Patient.findOne({ userUid: req.params.id });
        const patientAppointments = await AppointmentModel.find({ patientUid: req.params.id });

        // add users data to patientData
        let patientData = {
            email: data[0].email,
            name: data[0].name,
            address: users.address,
            telephone: users.telephone,
            birthday: users.birthday,
            gender: users.gender,
            appointments: patientAppointments
        }

        console.log(patientData);
        data[0]['password'] = undefined;

        res.status(200).json({ data: patientData });
    }
    catch (error) {
        res.status(500).json({ message: error.message })
    }
});

module.exports = user;