resource "aws_kms_key" "tableau1" {
  description         = "${lookup(var.taggingstandard, "deployment")}-TABLEAU1"
  enable_key_rotation = true
   policy = <<EOF

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Allow KMS Use",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${var.account_id}:root",
                    "arn:aws:iam::${var.account_id}:role/gehc-devopsbot",
                    "arn:aws:iam::${var.account_id}:role/gehc-devops"
                ]
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": "${var.account_id}"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:CallerAccount": "${var.account_id}",
                    "kms:ViaService": "s3.${var.aws_region}.amazonaws.com"
                }
            }
        },
            {
      "Sid": "example-statement-ID",
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
    ]
}
     
EOF
  tags = merge(
    var.taggingstandard,
    map("Name", "${lookup(var.taggingstandard, "deployment")}-TABLEAU1")
  )
}
/*data "aws_iam_policy_document" "kmskey_policy" {
  
  statement {
    sid = "Allow KMS Use"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
     principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:role/gehc-devopsbot","arn:aws:iam::${var.account_id}:root"]
    }
    resources = [
    "arn:aws:kms:us-east-1:${var.account_id}:key/4ec76dbb-1df4-47ab-80bc-c88cada06d0d"
    ]
  }
}*/