const express = require('express');
const admin = express.Router();
const AdminModel = require('../model/admin');
const UserModel = require('../model/user');
const AppointmentModel = require('../model/appointment');
const password = require('../services/password');
const { generateToken } = require("../utills/generatetoken");
const { protect } = require('../middleware/authMiddleware');

const authorizeModel = require('../middleware/authMiddleware');

// const authorize = (...roles) => {
//     return (req, res, next) => {
//         if (!roles.includes(req.user.role)) {
//             return next(createError(403, "Not authorized to access this route"));
//         }
//         next();
//     };
// };

// get authorize function from authMiddleware
// const { authorize } = require('../middleware/authMiddleware');

admin.get('/', async (req, res) => {
    res.status(200).json({ msg: 'admin' });
});

// get test
admin.get('/test', authorizeModel.authorize('admin'), async (req, res) => {
    // console.log(req.body);


    res.status(200).json({ msg: 'admin test', data: req.body });
});

// const authorize = (...roles) => {
//     return (req, res, next) => {
//       if (!roles.includes(req.user.role)) {
//         return next(createError(403, "Not authorized to access this route"));
//       }
//       next();
//     };
//   };

// newTest route only for admin use authorize('admin')
// admin.get('/testnew', authorize, async (req, res) => {
//     res.status(200).json({ msg: 'admin test', data: req.body });
// });


// admin.post('/create/:doctor', async (req, res) => {

//     try {
//         const data = await UserModel.User.find({ email: req.body.email });

//         if (data.length > 0) {
//             res.status(900).json({ message: 'Already have an account!' });
//             return;
//         }

//         password.cryptPassword(req.body.password, async function (err, hash) {

//             const data = new UserModel.User({
//                 name: req.body.name,
//                 email: req.body.email,
//                 password: hash,
//                 role: 'doctor',
//             });

//             const dataToSave = await data.save();

//             const doctor = new UserModel.Doctor({
//                 userUid: dataToSave.id,
//                 specialization: req.body.specialization,
//                 regNumber: req.body.regNumber,
//                 address: req.body.address,
//                 telephone: req.body.telephone
//             });

//             console.log(dataToSave)

//             doctor.save((err, data) => {
//                 if (err) {
//                     UserModel.User.deleteOne({ _id: dataToSave.id }, (err) => { });

//                     res.status(400).json({ message: err.message });
//                     return;
//                 }

//                 res.status(200).json({ uid: dataToSave.id });
//             });

//         });
//     }
//     catch (error) {
//         res.status(400).json({ message: error.message });
//     }

// });

admin.post('/create/:staff', authorizeModel.authorize('admin'), async (req, res) => {

    try {
        const data = await UserModel.User.find({ email: req.body.email });

        if (data.length > 0) {
            res.status(900).json({ message: 'This email is already registered!' });
            return;
        }

        password.cryptPassword(req.body.password, async function (err, hash) {

            const data = new UserModel.User({
                name: req.body.name,
                email: req.body.email,
                password: hash,
                role: req.body.role,
            });

            const dataToSave = await data.save();

            // activeTimes: {
            //     type: Array,
            //     "default" : []
            //   }

            const actimeTimes = `[
                {
                  time: "10:00 AM",
                  max: 10,
                },
                {
                  time: "03:30 PM",
                  max: 15,
                }
            ]`;

            const activeTimesStr = '[{"time": "10:00 AM", "max": 10}, {"time": "03:30 PM", "max": 15}]';
            const activeTimesArr = JSON.parse(activeTimesStr);
            console.log(activeTimesArr);
            console.log(JSON.parse(req.body.activeTimes));

            const doctor = new UserModel.Doctor({
                userUid: dataToSave.id,
                specialization: req.body.specialization,
                regNumber: req.body.regNumber,
                address: req.body.address,
                telephone: req.body.telephone,
                activeTimes: JSON.parse(req.body.activeTimes)
            });

            // samp[le array from active times

            // time and number of maxim um oatients for the time
            // [{ "time": "09:00:00.000Z", "max": 10 }, { "time": "09:30:00.000Z", "max": 10 }, ]


            console.log(dataToSave)

            doctor.save((err, data) => {
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

// update doctor
admin.post("/update/:doctor", authorizeModel.authorize('admin', 'doctor'), async (req, res) => {

    console.log(req.params);

    try {
        await UserModel.Doctor.updateOne(
            { userUid: req.params.doctor },
            {
                specialization: req.body.specialization,
                regNumber: req.body.regNumber,
                address: req.body.address,
                telephone: req.body.telephone,
                activeTimes: JSON.parse(req.body.activeTimes)
            }
        );

        await UserModel.User.updateOne(
            { _id: req.params.doctor },
            {
                name: req.body.name,
                email: req.body.email
            }
        );

        // hash the password
        // password.cryptPassword(req.body.password, async function (err, hash) {
        //     await UserModel.User.updateOne(
        //         { _id: req.params.doctor },
        //         {
        //             name: req.body.name,
        //             email: req.body.email,
        //             password: hash,
        //         }
        //     );
        // });


        res.status(200).json({ message: "Updated Successfully!" });
    } catch (error) {
        res.status(400).json({ message: error.message });
        console.log(error);
    }
});

// drug.get("/all", async (req, res) => {

//     try {
//         const data = await DrugModel.find({});

//         res.status(200).json(data);
//     }
//     catch (error) {
//         res.status(400).json({ message: error.message });
//     }

// });

// doctor list
admin.get("/all/:doctor", async (req, res) => {

    try {
        const data = await UserModel.Doctor.find({});
        // const users = await UserModel.User.find({});

        // get all users with role doctor
        const users = await UserModel.User.find({ role: 'doctor' });

        // console.log(data);

        // get the user data for each doctor
        const doctorData = [];
        for (let i = 0; i < data.length; i++) {

            console.log(data[i].userUid);

            const userData = users.find(user => user._id == data[i].userUid);
            console.log(userData);

            if (userData != undefined) {
                doctorData.push({
                    userUid: data[i].userUid,
                    name: userData.name,
                    email: userData.email,
                    specialization: data[i].specialization,
                    regNumber: data[i].regNumber,
                    address: data[i].address,
                    telephone: data[i].telephone,
                    // active times ouput as array
                    activeTimes: data[i].activeTimes
                });
            }

            // doctorData.push({
            //     _id: data[i]._id,
            //     userUid: data[i].userUid,
            //     name: userData.name,
            //     email: userData.email,
            //     specialization: data[i].specialization,
            //     regNumber: data[i].regNumber,
            //     address: data[i].address,
            //     telephone: data[i].telephone
            // });
        }

        // res.status(200).json(data);
        res.status(200).json(doctorData);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }

});

// get one doctor
admin.get("/one/:doctor", authorizeModel.authorize('admin', 'doctor'), async (req, res) => {
    try {

        const data = await UserModel.Doctor.findOne({ userUid: req.params.doctor });
        const userData = await UserModel.User.findOne({ _id: req.params.doctor });
        const appointments = await AppointmentModel.find({ doctorUid: req.params.doctor });
        // console.log(data);

        res.status(200).json({
            userUid: data.userUid,
            name: userData.name,
            email: userData.email,
            specialization: data.specialization,
            regNumber: data.regNumber,
            address: data.address,
            telephone: data.telephone,
            // active times ouput as array
            activeTimes: data.activeTimes,
            appointments: appointments
        });
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
});




// admin.post('/create', async (req, res) => {

//     try{
//         const data = await AdminModel.find({username : req.body.username});

//         if(data.length > 0){
//             res.status(900).json({ message: 'Already have an account!' });
//             return;
//         }

//         password.cryptPassword(req.body.password, async function(err, hash) {

//             const data = new AdminModel({
//                 name: req.body.name,
//                 username: req.body.username,
//                 password: hash,
//             });

//             // console.log(data);

//             const dataToSave = await data.save();
//             res.status(200).json({uid: dataToSave.id});
//         });
//     }
//     catch (error) {
//         res.status(400).json({ message: error.message });
//     }

// });

admin.post('/login', async (req, res) => {
    try {
        const data = await AdminModel.find({ username: req.body.username });

        if (data.length === 0) {
            res.status(401).json({ message: 'Login failed!' });
            return;
        }

        password.comparePassword(req.body.password, data[0]['password'], async function (err, isPasswordMatch) {

            if (!isPasswordMatch) {
                res.status(401).json({ message: 'Login failed!' });
                return;
            }

            // send jwt token

            const token = await generateToken(data[0]['id']);


            // let token = await password.generateToken(data[0]['id']);

            res.status(200).json({ uid: data[0]['id'], token: token });
        });
    }
    catch (error) {
        res.status(500).json({ message: error.message })
    }
});


module.exports = admin;