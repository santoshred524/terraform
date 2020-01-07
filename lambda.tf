# Cloudwatch event rule
resource "aws_cloudwatch_event_rule" "tag-ec2-event" {
    name = "${var.project_name}-tag-ec2-event"
    description = "tag-ec2-event"
##cronjob every 2 hrs
    schedule_expression = "cron(0 12 */1 * ? *)"
    tags = {
      Project = "${var.project_name}"
  }
}

# Cloudwatch event target
resource "aws_cloudwatch_event_target" "tag-ec2-event-lambda-target" {
    target_id = "${var.project_name}-tag-ec2-event-lambda-target"
    rule = "${aws_cloudwatch_event_rule.tag-ec2-event.name}"
    arn = "${aws_lambda_function.tag-ec2.arn}"
    input     = "{\"commands\":[\"snap-creation-event\"]}"

}


resource "aws_lambda_function" "tag-ec2" {
  filename      = "${path.module}/tag-ec2.zip"
  function_name = "${var.project_name}-snap-create"
  role          = "${aws_iam_role.concou-lambda_role.arn}"
  handler       = "lambda_function.lambda_handler"
    tags = {
      Project = "${var.project_name}"
  }
  timeout       = 300
  depends_on    = ["aws_iam_role.concou-lambda_role"]

  source_code_hash = "${base64sha256(file("${path.module}/tag-ec2.zip"))}"

  runtime = "python3.6"

  environment {
    variables = {
	   aws_regions = "${var.region}"
     Project = "${var.project_name}"
    }
  }
}

resource "aws_cloudwatch_log_group" "tag-ec2-log" {
  name              = "/aws/lambda/${aws_lambda_function.tag-ec2.function_name}"
  # retention_in_days = 0
  tags = {
      Project = "${var.project_name}"
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_creation" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.tag-ec2.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.tag-ec2-event.arn}"
}
