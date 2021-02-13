async function middleware(req, res, fn) {
  const event = {
    headers: req.headers,
    params: req.params,
    query: req.query,
    body: req.body,
  };

  const result = await fn(event);

  return res.status(result.status).send(result.body);
}

module.exports = { middleware };
