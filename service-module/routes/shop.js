const express = require('express')
const router = express.Router()

const shopController = require('../controllers/shop')
const verifyToken = require('../middleware/auth')

router.get('/get-all-products', verifyToken, shopController.getAllProducts)

router.post('/search-products', verifyToken, shopController.searchProducts)


module.exports = router