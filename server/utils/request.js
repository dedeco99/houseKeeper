function response(status, message, data) {
  return {
    status,
    body: {
      message,
      data,
    },
  };
}

function error(status, message, data) {
  return {
    status,
    body: {
      message,
      data,
    },
  };
}

module.exports = { response, error };
