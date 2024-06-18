AWSTemplateFormatVersion: '2010-09-09'
Resources:
  CrossAccountRole:
    Type: 'AWS::IAM::Role'
    Properties:
      Description: 'Role for authenticating Spacelift with default methods, not OIDC, to the an account in the ${name} OU.'
      RoleName: '${organization}-role-${name}-spacelift_default'
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: 'Allow'
            Principal:
              AWS:
                - 'arn:aws:iam::324880187172:root'  # Spacelift's own AWS ID
            Action: 'sts:AssumeRole'
            Condition:
              StringLike:
                sts:ExternalId:
                  - '${organization}-github@*@${trusted_stack_name}@*'
%{ if length(set_of_policy_arns) > 0 }
      ManagedPolicyArns:
%{ for arn in set_of_policy_arns }
        - ${arn}
%{ endfor }
%{ endif }