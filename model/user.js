const mongoose = require("mongoose");
const Schema = mongoose.Schema;

// User schema
const userSchema = new Schema(
  {
    name: {
      type: String,
      required: [true, 'Name is required.']
    },
    email: {
      type: String,
      required: [true, 'Email is required.'],
      unique: true,
      match: [/^[^\s@]+@[^\s@]+\.[^\s@]+$/, 'Invalid email.']
    },
    password: {
      type: String,
      required: [true, 'Password is required.']
    },
    role: {
      type: String,
      enum: ['patient', 'doctor', 'nurse', 'admin'],
      required: [true, 'Role is required.']
    },
  },
  {
    timestamps: true,
  }
);

const User = mongoose.model('user', userSchema);
// module.exports = mongoose.model("user", userSchema);

// Patient schema
const patientSchema = new Schema(
  {
    userUid: {
      type: String,
      required: [true, 'User ID is required.']
    },
    // age: {
    //   type: Number,
    //   min: [0, 'Age should be a positive number.'],
    //   required: [true, 'Age is required.']
    // },
    gender: {
      type: String,
      enum: ['male', 'female', 'other'],
      required: [true, 'Gender is required.']
    },
    medicalHistory: String,
    allergies: String,
    prescriptions: [String],
    address: String,
    telephone: String,
    // DOB
    birthday: {
      type: String,
      required: [true, 'Birthday is required.']
    }
  },
  {
    timestamps: true,
  }
);

const Patient = mongoose.model('patient', patientSchema);

// Doctor schema
const doctorSchema = new Schema(
  {
    userUid: {
      type: String,
      required: [true, 'User ID is required.']
    },
    appointments: [String],
    regNumber: {
      type: String,
      required: [true, 'Registration number is required.'],
      unique: true
    },
    specialization: String,
    address: String,
    telephone: String,
    // doctor active times array
    activeTimes: {
      type: Array,
      "default" : []
    }
  },
  {
    timestamps: true,
  }
);

const Doctor = mongoose.model('doctor', doctorSchema);

// Nurse schema
const nurseSchema = new Schema(
  {
    userUid: {
      type: String,
      required: [true, 'User ID is required.']
    },
    department: {
      type: String,
      required: [true, 'Department is required.']
    },
    shift: {
      type: String,
      required: [true, 'Shift is required.']
    },
    patients: [String],
    address: String,
    telephone: String
  },
  {
    timestamps: true,
  }
);

const Nurse = mongoose.model('nurse', nurseSchema);

module.exports = { User, Patient, Doctor, Nurse };
