# aws-terraform-gha-vpc-peering

## AWS STS (Security Token Service)

It is a web service that allows you to request temporary, limited-privilege credentials for user and applications. 

To generate STS (Security Token Service) you need to perform the following actions:

- Have an user (or use your administrator user).
- Generate Access & Secret Keys.
- Configure locally these keys using **vi ~/.aws/credentials** cli command.
- Assign an [inline policy](./aws_policies/allowUserToGetTempCred.json) to the user who will be used to generate STS credentials.
- Assign the user into a Group.
- Attached Policy into the Group **(AmazonVPCFullAccess)**.
- Assign MFA devide for the user (IAM -> Users -> user-name -> Security credentials).
- From your terminal execute the following command, add your credentials.

```
aws sts get-session-token --duration-seconds <time-in-seconds> --serial-number arn:aws:iam::<your-aws-account>:mfa/<user-name>-MFA --token-code <tokenid>

example:
aws sts get-session-token --duration-seconds 3600 --serial-number arn:aws:iam::12345:mfa/user1-MFA --token-code 67890

The generated credentials will be valid for 1 hour.
```

- Add these credentials into your aws credentials file (vi ~/.aws/credentials)

