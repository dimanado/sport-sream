unless Rails.env.production?
	Braintree::Configuration.environment = :sandbox
	Braintree::Configuration.merchant_id = "7d7m273qpn6cfvd7"
	Braintree::Configuration.public_key = "3gx9tg7rtft5hsbr"
	Braintree::Configuration.private_key = "4b2f0a1a5d2c0010b87017347c07c507"
else
	Braintree::Configuration.environment = :production
	Braintree::Configuration.merchant_id = "377qpscfgqn6cbkr"
	Braintree::Configuration.public_key = "kyc8sn43z48dhpgx"
	Braintree::Configuration.private_key = "bceb12cf1988c78a748763c0c02e08c0"
end

