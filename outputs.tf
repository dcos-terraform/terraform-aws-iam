output "aws_agent_profile" {
  value       = "${aws_iam_instance_profile.agent_profile.name}"
  description = "Name of the agent profile"
}

output "aws_master_profile" {
  value       = "${aws_iam_instance_profile.master_profile.name}"
  description = "Name of the masters profile"
}
