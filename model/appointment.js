const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const appointmentSchema = new Schema(
    {
        patientUid: {
            type: String,
            required: [true, "Patient ID is required."],
        },
        doctorUid: {
            type: String,
            required: [true, "Doctor ID is required."],
        },
        date: {
            type: String,
            required: [true, "Date is required."],
        },
        time: {
            type: String,
            required: [true, "Time is required."],
        },
        status: {
            type: String,
            required: [true, "Status is required."],
        },
    },
    {
        timestamps: true,
    }
);

module.exports = mongoose.model("appointment", appointmentSchema);