const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// patient report schema
const reportSchema = new Schema(
    {
        patientUid: {
            type: String,
            required: [true, 'Patient ID is required.']
        },
        doctorUid: {
            type: String,
            required: [true, 'Doctor ID is required.']
        },
        appointmentUid: {
            type: String,
            required: [true, 'Appointment ID is required.']
        },
        diseaseReason: String,
        // prescriptions: [String],
        prescriptions: String,
        // prescriptions: {
        //     type: Array,
        //     "default": []
        // },
        treatmentPlan: String,
        progressNotes: String,
    },
    {
        timestamps: true,
    }
);

// const Report = mongoose.model('report', reportSchema);
// module.exports = mongoose.model("appointment", appointmentSchema);

module.exports = mongoose.model('report', reportSchema);