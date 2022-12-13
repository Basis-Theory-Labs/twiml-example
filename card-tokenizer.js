module.exports = async function (req) {
  const { bt, args: { body, headers } } = req;

  let forwardedBody = body;

  try {
    const params = new URLSearchParams(body);
    const digits = params.get('Digits');
    if (digits) {

      const token = await bt.tokenize({
        type: 'card_number',
        data: digits,
      });

      params.set('Digits', token.id);

      forwardedBody = params.toString();
    }
  } catch {
    forwardedBody = 'error'
  }

  return {
      body: forwardedBody,
      headers
  }
};
