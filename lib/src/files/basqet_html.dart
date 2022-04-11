String buildBasqetHtml(
  String publicKey,
  String amount,
  String email,
  String description,
  String currency,
) =>
    '''
<html>
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Basqet checkout</title>
    <script src="https://checkout.basqet.com/static/prod/basqet.js"></script>
  </head>
  <body
    onload="setupBasqetConnect()"

    style="
      border-radius: 20px;
      background-color: #fff;
      height: 100vh;
      overflow: hidden;
    "
  >
    <script type="text/javascript">

        window.onload = setupBasqetConnect;

        function setupBasqetConnect() {

          window.payWithBasqet({
            amount: "$amount",
            email: "$email",
            description: "$description",
            currency: "$currency",
            public_key: "$publicKey",
            onSuccess: (ref) => sendMessage({"event": "checkout.success", "transaction_reference": ref}),
            onError: (error) => sendMessage({"event": "checkout.error", "data": error}),
            onClose: () => sendMessage({"event": "checkout.closed"}),
          });

          function sendMessage(message) {
            if (window.BasqetClientInterface && window.BasqetClientInterface.postMessage) {
                BasqetClientInterface.postMessage(JSON.stringify(message));
            }
          }
        }

    </script>
  </body>
</html>

''';
