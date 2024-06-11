AWSTemplateFormatVersion: '2010-09-09'
Resources:
  CrossAccountRole:
    Type: 'AWS::IAM::Role'
    Properties:
      Description: 'Role for authenticating Spacelift with default methods, not OIDC, to the ${name} account.'
      RoleName: '${organization}-role-${name}-spacelift_default'
      AssumeRolePolicyDocument:

      Policies:
        - PolicyName: 'SpaceliftAccessPolicy'
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: 'Allow'
                Action: 'ec2:DescribeInstances'
                Resource: '*'