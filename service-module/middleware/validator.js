const { check } = require('express-validator')

const validateLogin = [
    check('email', 'Email does not empty').not().isEmpty(),
    check('password', 'Password does not empty').not().isEmpty(),
]

const validateSignup = [
    check('email', 'Email does not empty').not().isEmpty(),
    check('email', 'Invalid email').isEmail(),
    check('displayName', 'Display name does not empty').trim().not().isEmpty(),
    check('password', 'Password more than 6 characters').isLength({ min: 6 }),
]

module.exports = { validateLogin, validateSignup }