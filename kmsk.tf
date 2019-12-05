
data "aws_caller_identity" "current" {}

resource "aws_kms_key" "key-protecting-rds-db" {
    //cac230cb-a9d4-4f99-8ade-45828e4d7073
    description             = "Default master key that protects my RDS database volumes when no other key is defined"
    key_usage               = "ENCRYPT_DECRYPT"
    is_enabled              = true
    enable_key_rotation     = true

    policy = <<POLICY
{
  "Version" : "2012-10-17",
  "Id" : "auto-rds-2",
  "Statement" : [ {
    "Sid" : "Allow access through RDS for all principals in the account that are authorized to use RDS",
    "Effect" : "Allow",
    "Principal" : {
      "AWS" : "*"
    },
    "Action" : [ "kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*", "kms:GenerateDataKey*", "kms:CreateGrant", "kms:ListGrants", "kms:DescribeKey" ],
    "Resource" : "*",
    "Condition" : {
      "StringEquals" : {
        "kms:CallerAccount" : "534685708436",
        "kms:ViaService" : "rds.eu-central-1.amazonaws.com"
      }
    }
  }, {
    "Sid" : "Allow direct access to key metadata to the account",
    "Effect" : "Allow",
    "Principal" : {
      "AWS" : "arn:aws:iam::0534685708436:root"
    },
    "Action" : [ "kms:Describe*", "kms:Get*", "kms:List*", "kms:RevokeGrant" ],
    "Resource" : "*"
  } ]
}
POLICY
}


//data "aws_caller_identity" "current" {}
//
//data "aws_iam_policy_document" "cmk_key_policy" {
//    statement {
//        sid = "Allow access through RDS for all principals in the account that are authorized to use RDS"
//
//        effect = "Allow"
//
//        principals {
//        type = "AWS"
//        identifiers = [
//            "*"
//            ]
//        }
//
//        actions = [
//        //"kms:*"
//            "kms:Encrypt", "kms:Decrypt", "kms:ReEncrypt*", "kms:GenerateDataKey*", "kms:CreateGrant", "kms:ListGrants", "kms:DescribeKey"
//        ]
//
//        resources = [
//        "*"
//        ]
//    }
//
//    statement {
//        sid = "Allow direct access to key metadata to the account"
//
//        effect = "Allow"
//
//        principals {
//            type = "AWS"
//            identifiers = [
//                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
//            ]
//        }
//
//        actions = [
//            //"kms:*"
//            "kms:Describe*", "kms:Get*", "kms:List*", "kms:RevokeGrant"
//        ]
//
//        resources = [
//            "*"
//        ]
//    }
//}
//
//
//locals {
//    tags = {
//        SYSTEM                = "DigiToll"
//        OWNER                 = "HyperAspect"
//        ENV_NAME              = var.environment
//        DESCRIPTION           = "Default master key that protects my RDS database volumes when no other key is defined"
//        MANAGED_BY            = "Terraform"
//    }
//}
//
//resource "aws_kms_key" "key" {
//    key_usage               = "ENCRYPT_DECRYPT"
//    policy                  = data.aws_iam_policy_document.cmk_key_policy.json
//    is_enabled              = true
//    enable_key_rotation     = true
//    tags                    = local.tags
//}
//
//resource "aws_kms_alias" "key_alias" {
//    name                    = "alias/${var.key_alias_name}"
//    target_key_id           = aws_kms_key.key.id
//}



