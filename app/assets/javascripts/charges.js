document.addEventListener("turbolinks:load", function() {
  const public_key = document.querySelector("meta[name='stripe-public-key']").content;
  const stripe = Stripe(public_key);
  const elements = stripe.elements();

  var style = {
    base: {
      // Add your base input styles here. For example:
      fontSize: '16px',
      color: "#32325d",
    }
  };

  // Create an instance of the card Element.
  var card = elements.create('card', {style: style});

  // Add an instance of the card Element into the `card-element` <div>.
  card.mount('#card-element');

  card.addEventListener('change', function(event) {
    var displayError = document.getElementById('card-errors');
    if (event.error) {
      displayError.textContent = event.error.message;
    } else {
      displayError.textContent = '';
    }
  });

  var form = document.getElementById('new_job');
  form.addEventListener('submit', function(event) {
    event.preventDefault();

    stripe.createToken(card).then(function(result) {
      if (result.error) {
        // Inform the customer that there was an error.
        var errorElement = document.getElementById('card-errors');
        errorElement.textContent = result.error.message;
      } else {
        // Send the token to your server.
        stripeTokenHandler(result.token);
      }
    });
  });



});

function stripeTokenHandler(token) {
// Insert the token ID into the form so it gets submitted to the server
  var form = document.getElementById('new_job');
  var hiddenInput = document.createElement('input');
  hiddenInput.setAttribute('type', 'hidden');
  hiddenInput.setAttribute('name', 'stripeToken');
  hiddenInput.setAttribute('value', token.id);
  form.appendChild(hiddenInput);

  ["brand", "exp_month", "exp_year", "last4"].forEach(function(field) {
       addFieldToForm(form, token, field);
    });
  // Submit the form
  form.submit();
}

function addFieldToForm(form, token, field) {
  var hiddenInput = document.createElement('input');
  hiddenInput.setAttribute('type', 'hidden');
  hiddenInput.setAttribute('name', "user[card_" + field + "]");
  hiddenInput.setAttribute('value', token.card[field]);
  form.appendChild(hiddenInput);
}
