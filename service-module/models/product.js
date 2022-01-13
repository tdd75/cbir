const mongoose = require('mongoose')

const productSchema = mongoose.Schema({
    productId: {
        type: String,
        required: true,
    },
    productName: {
        type: String,
        required: true,
    },
    productImage: {
        type: String,
        required: true,
    },
    productPrice: {
        type: Number,
        required: true,
    },
    productDiscount: {
        type: Number,
        required: true,
    },
    ratingStar: {
        type: Number,
        required: true,
    },
    sold: {
        type: Number,
        required: true,
    },
    isFreeship: {
        type: Boolean,
        required: true,
    },
    shopLocation: {
        type: String,
        required: true,
    },
    category: {
        type: String,
        required: true,
    },
    isFavorite: {
        type: Boolean,
        required: true,
    },
})

module.exports = mongoose.model('Product', productSchema)