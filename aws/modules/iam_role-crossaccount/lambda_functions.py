import boto3
import json

def lambda_handler(event, context):
    target_account_id = event['TargetAccountId']
    role_name = event['RoleName']
    organization = event['Organization']
    env = event['Env']
    name = event['Name']
    policy_document = event['PolicyDocument']

    assume_role_policy_document = {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::324880187172:root"  # Spacelift's own AWS ID
                },
                "Action": "sts:AssumeRole",
                "Condition": {
                    "StringLike": {
                        "sts:ExternalId": [
                            f"{organization}-github@*@{organization}-stack-{env}-aws_{name}@*",
                            f"{organization}-github@*@{organization}-stack-{env}-spacelift@*"
                        ]
                    }
                }
            }
        ]
    }

    # Assume the role in the target account
    sts_client = boto3.client('sts')
    assumed_role = sts_client.assume_role(
        RoleArn=f'arn:aws:iam::{target_account_id}:role/OrganizationAccountAccessRole',
        RoleSessionName='CreateIAMRoleSession'
    )
    
    credentials = assumed_role['Credentials']
    
    # Create an IAM client using the assumed role credentials
    iam_client = boto3.client(
        'iam',
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken']
    )
    
    try:
        # Attempt to get the IAM role details
        role = iam_client.get_role(RoleName=role_name)
        # If the role exists, update the assume role policy
        iam_client.update_assume_role_policy(
            RoleName=role_name,
            PolicyDocument=json.dumps(assume_role_policy_document)
        )
    except iam_client.exceptions.NoSuchEntityException:
        # If the role doesn't exist, create it
        iam_client.create_role(
            RoleName=role_name,
            AssumeRolePolicyDocument=json.dumps(assume_role_policy_document)
        )
    
    # Attach the policy to the IAM role
    iam_client.put_role_policy(
        RoleName=role_name,
        PolicyName='SpaceliftPermissions',
        PolicyDocument=json.dumps(policy_document)
    )

    return {
        'statusCode': 200,
        'body': f'IAM role {role_name} created/updated successfully in account {target_account_id}.'
    }
