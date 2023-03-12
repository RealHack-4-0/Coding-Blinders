const express = require('express');
const appointment = express.Router();
const UserModel = require('../model/user');
const AppointmentModel = require('../model/appointment');
const password = require('../services/password');
const { generateToken } = require("../utills/generatetoken");

const authorizeModel = require('../middleware/authMiddleware');

appointment.get('/', async (req, res) => {
    res.status(200).json({ msg: 'appointment' });
});

// get test
appointment.get('/test', authorizeModel.authorize('patient'), async (req, res) => {
    // console.log(req.body);

    res.status(200).json({ msg: 'appointment test', data: req.body });
});


// new appointment
appointment.post('/create', authorizeModel.authorize('admin', 'patient'), async (req, res) => {


    try {

        // get req.body.doctor and search for doctor in doctor collection
        // AppointmentModel.countDocuments({
        //     doctorUid: req.body.doctor,
        //     date: req.body.date,
        //     time: req.body.time
        // })
        //     .then(count => {
        //         console.log(`The doctor has ${count} appointments at ${req.body.time} on ${req.body.date}`);
        //     })
        //     .catch(error => {
        //         console.error(error);
        //     })


        // console.log(`The doctor has ${count} appointments at ${req.body.time} on ${req.body.date}`);

        const doctor = await UserModel.Doctor.find({ userUid: req.body.doctor });
        if (doctor.length === 0) {
            res.status(400).json({ message: 'Doctor not found' });
            return;
        }

        // get doctor active times and appointments
        const doctorActiveTimes = doctor[0].activeTimes;

        // {
        //     "_id": {
        //       "$oid": "640cde46fef7c4f7550c4482"
        //     },
        //     "userUid": "640cde46fef7c4f7550c4480",
        //     "appointments": [],
        //     "regNumber": "888987987",
        //     "specialization": "Family",
        //     "address": "155/2A",
        //     "telephone": "077654987",
        //     "activeTimes": [
        //       {
        //         "time": "10:00 AM",
        //         "max": 10
        //       },
        //       {
        //         "time": "03:30 PM",
        //         "max": 5
        //       }
        //     ],
        //   }

        // check if doctor is available at a given time and has not exceeded the max number of appointments on that time on that day

        // check if doctor is available at that time in the activeTimes array
        if (doctor[0].activeTimes.length > 0) {
            const time = doctor[0].activeTimes.find(time => time.time === req.body.time);
            if (time) {

                const count = await AppointmentModel.countDocuments({
                    doctorUid: req.body.doctor,
                    date: req.body.date,
                    time: req.body.time
                });

                console.log(`The doctor has ${count} appointments at ${req.body.time} on ${req.body.date}`);
                // return;
                // check if the doctor has reached the max number of appointments
                if (time.max > count) {

                    // check if the patient has already booked an appointment with the doctor on that day
                    const patientAppointments = await AppointmentModel.find({
                        patientUid: req.body.patient,
                        date: req.body.date,
                        time: req.body.time
                    });

                    if (patientAppointments.length > 0) {
                        res.status(400).json({ message: 'Patient has already booked an appointment with the doctor on that day' });
                        return;
                    }

                    // create appointment
                    const data = new AppointmentModel({
                        date: req.body.date,
                        time: req.body.time,
                        doctorUid: req.body.doctor,
                        patientUid: req.body.patient,
                        status: "active",
                    });

                    const dataToSave = await data.save();
                    res.status(200).json({ id: dataToSave.id });
                }
                else
                    res.status(400).json({ message: 'Doctor has reached the max number of appointments' });

            }
            else
                res.status(400).json({ message: 'Doctor is not available at that time' });

        }
        else
            res.status(400).json({ message: 'Doctor is not available at that time' });





        // const data = new AppointmentModel({
        //     date: req.body.date,
        //     time: req.body.time,
        //     doctorUid: req.body.doctor,
        //     patientUid: req.body.patient,
        //     status: "active",
        // });

        // const dataToSave = await data.save();
        // res.status(200).json({ id: dataToSave.id });
    }

    catch (error) {
        res.status(400).json({ message: error.message });
    }
});

// get all appointments


module.exports = appointment;