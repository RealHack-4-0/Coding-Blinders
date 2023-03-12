const express = require('express');
const { protect } = require('../middleware/authMiddleware');
const drug = express.Router();
const DrugModel = require('../model/drug');
const { generateToken } = require("../utills/generatetoken");

drug.get('/', async (req, res) => {
    res.status(200).json({ msg: 'drug' });
});

// require auth headers.authorization
// use mi
drug.get('/test', protect, async (req, res) => {
    // console.log(req.body);
    res.status(200).json({ msg: 'drug test', data: req.body });
});

drug.post('/create', protect, async (req, res) => {
    // require auth headers.authorization
    // use mi

    try {
        const data = new DrugModel({
            name: req.body.name,
        });

        const dataToSave = await data.save();
        res.status(200).json({ id: dataToSave.id });
    }

    catch (error) {
        res.status(400).json({ message: error.message });
    }
});

drug.get("/all", async (req, res) => {

    try {
        const data = await DrugModel.find({});

        res.status(200).json(data);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }

});

drug.get("/:name", async (req, res) => {

    try {
        const data = await DrugModel.find({ name: req.params.name });

        res.status(200).json(data[0]);
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }

});

drug.get("/delete/:name", async (req, res) => {

    try {
        await DrugModel.findOneAndDelete({ name: req.params.name });

        res.status(200).json({ message: "Deleted successful!" });
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }

});

module.exports = drug;