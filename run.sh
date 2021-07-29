aws iam create-role --role-name lambda-example \
      --assume-role-policy-document file://policy.json \
      | tee logs/role.log

zip function.zip index.js

aws lambda create-function --function-name hello-cli \
  --zip-file fileb://function.zip \
  --handler index.handler \
  --runtime nodejs12.x \
  --role arn:aws:iam::847653228695:role/lambda-example \
  | tee logs/lambda-create.log

aws lambda invoke \
  --function-name hello-cli \
  --log-type Tail \
  logs/lambda-exec.log

zip function.zip index.js

aws lambda update-function-code \
  --zip-file fileb://function.zip \
  --function-name hello-cli \
  --publish \
  | tee logs/lambda-update.log

aws lambda delete-function --function-name hello-cli 

aws iam delete-role --role-name lambda-example