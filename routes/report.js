const express = require('express');
const report = express.Router();
const UserModel = require('../model/user');
const ReportModel = require('../model/report');
const AppointmentModel = require('../model/appointment');
const password = require('../services/password');
const { generateToken } = require("../utills/generatetoken");
const { getUserFromToken } = require("../utills/getUser");

const authorizeModel = require('../middleware/authMiddleware');

report.get('/', async (req, res) => {
    res.status(200).json({ msg: 'report' });
});

// get test
report.get('/test', authorizeModel.authorize('patient'), async (req, res) => {
    // console.log(req.body);

    res.status(200).json({ msg: 'report test', data: req.body });
});

// patientUid: {
//     type: String,
//     required: [true, 'Patient ID is required.']
// },
// doctorUid: {
//     type: String,
//     required: [true, 'Doctor ID is required.']
// },
// appointmentUid: {
//     type: String,
//     required: [true, 'Appointment ID is required.']
// },
// diseaseReason: String,
// prescriptions: [String],
// treatmentPlan: String,
// progressNotes: String,

// create report
report.post('/create', authorizeModel.authorize('doctor'), async (req, res) => {

    try {
        const user = await getUserFromToken(req.headers.authorization);
        console.log(user);

        // check if there is an appointment with the given appointmentUid and doctorUid and patientUid
        const appointment = await AppointmentModel.find({
            _id: req.body.appointmentUid,
            patientUid: req.body.patientUid,
        });

        if (appointment.length === 0) {
            res.status(400).json({ message: 'Appointment not found' });
            return;
        }

        // check if the doctorUid is the same as the doctorUid in the appointment
        if (appointment[0].doctorUid !== user.id) {
            console.log(appointment[0].doctorUid, user.id);
            res.status(400).json({ message: 'Only the doctor referred in the appointment can create a report' });
            return;
        }

        const report = new ReportModel({
            doctorUid: user.id,
            patientUid: req.body.patientUid,
            appointmentUid: req.body.appointmentUid,
            diseaseReason: req.body.diseaseReason,
            // prescriptions: JSON.parse(req.body.prescriptions),
            prescriptions: req.body.prescriptions,
            treatmentPlan: req.body.treatmentPlan,
            progressNotes: req.body.progressNotes,
        });

        // prescriptions array
        // [ { "name": "Paracetamol", "dosage": "2", "frequency": "3", "duration": "2" }, { "name": "Pinex", "dosage": "2", "frequency": "3", "duration": "2" } ]

        // Paracetamol 2 times a day for 2 days
        // Pinex 2 times a day for 2 days

        report.save((err, data) => {
            if (err) {
                res.status(400).json({ message: err.message });
                return;
            }

            res.status(200).json({ uid: data.id, message: 'report created' });
        });

        // const reportToSave = await report.save();
        // res.status(200).json({ msg: 'report created', data: reportToSave });
    } catch (error) {
        res.status(400).json({ message: error.message });
    }

});

// get report by appointmentUid
report.get('/get/:appointmentUid', authorizeModel.authorize('doctor', 'patient'), async (req, res) => {
    // only allow the patient or any doctor to get the report

    try {
        const user = await getUserFromToken(req.headers.authorization);

        // get the report
        const report = await ReportModel.find({ appointmentUid: req.params.appointmentUid });

        if (report.length === 0) {
            res.status(400).json({ message: 'Report not found' });
            return;
        }

        // check if the user is a patient
        if (user.role === 'patient') {
            // check if the patientUid is the same as the patientUid in the report
            if (report[0].patientUid !== user.id) {
                res.status(400).json({ message: 'Only the patient referred in the report can view the report' });
                return;
            }
        }

        res.status(200).json({ msg: 'report', data: report });

    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }

});




module.exports = report;