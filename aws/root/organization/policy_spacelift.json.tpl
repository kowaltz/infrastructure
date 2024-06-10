{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : [
          "324880187172"
        ]
      },
      "Action" : "sts:AssumeRole",
      "Condition" : {
        "StringLike" : {
          "sts:ExternalId" : [
            "${organization}-github@*@${organization}-stack-${env}-aws_${name}@*",
            "${organization}-github@*@${organization}-stack-${env}-spacelift@*",
          ]
        }
      }
    }
  ]
}