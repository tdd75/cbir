const Product = require('../models/product')

const getAllProducts = (req, res, next) => {
    Product.find().limit(20)
        .then(products => {
            res.status(200).json({
                code: 200,
                message: 'Get product data successfully.',
                data: products,
            })
        })
        .catch(err => {
            console.log(err)
        })
}

const searchProducts = (req, res, next) => {
    Product.find({ $text: { $search: req.body.text } }).limit(20)
        .then(products => {
            res.status(200).json({
                code: 200,
                message: 'Search products successfully.',
                data: products,
            })
        })
        .catch(err => {
            console.log(err)
        })
}

module.exports = { getAllProducts, searchProducts }