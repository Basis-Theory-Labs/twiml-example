const digitsRegex = /Digits=[\d-]*/;

module.exports = async function (req) {
  const { bt, args: { body, headers } } = req;

  let forwardedBody = body;

  try {
    const match = body.match(digitsRegex);
    if (match) {
      const digits = match[0].substring(7);

      const token = await bt.tokenize({
        type: 'card_number',
        data: digits,
      });

      forwardedBody = body.replace(digitsRegex, `Digits=${token.id}`);
    }
  } catch {
    forwardedBody = 'error'
  }

  return {
    raw: {
      body: forwardedBody,
      headers,
    }
  }
};
