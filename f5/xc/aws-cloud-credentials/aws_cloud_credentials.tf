module "aws_cloud_credentials" {
  count = ("" == var.aws_cloud_credentials_name) ? 1 : 0

  source = "github.com/f5shemyakin/terraform-xc-aws-cloud-credentials"
  # source  = "f5devcentral/aws-cloud-credentials/xc"
  # version = "0.0.3"

  name            = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  aws_access_key  = var.aws_create_iam_user ? null : try(coalesce(var.xc_aws_access_key, var.aws_access_key), null)
  aws_secret_key  = var.aws_create_iam_user ? null : try(coalesce(var.xc_aws_secret_key, var.aws_secret_key), null)
}
