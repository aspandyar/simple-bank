

```bash
$ aws secretsmanager get-secret-value --secret-id simple_bank --query SecretString --output text | jq -r 'to_entries|map("\(.key)=\(.value)")|.[]' > ~/Projects/simple-bank/app.env 
```


Advance using jq to convert format data


manual of using:
	https://jqlang.github.io/jq/manual/#invoking-jq

