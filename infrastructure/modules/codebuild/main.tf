resource "aws_iam_role_policy_attachment" "codebuild_s3_upload_attachment" {
  policy_arn = var.codebuildRole_arn
  role       = var.codebuildRole_name
}
