const { error } = require("./request");

module.exports = {
	badRequest: error(400, "BAD_REQUEST"),
	notFound: error(404, "NOT_FOUND"),
	requiredFieldsMissing: error(400, "REQUIRED_FIELDS"),
	duplicated: error(409, "DUPLICATED"),
	unauthorized: error(401, "UNAUTHORIZED"),
	forbidden: error(403, "FORBIDDEN"),

	userPasswordWrong: error(401, "USER_PASSWORD_WRONG"),
	userNotRegistered: error(401, "USER_NOT_REGISTERED"),
};
