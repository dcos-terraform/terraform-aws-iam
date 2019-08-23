output "aws_agent_profile" {
  value       = "${aws_iam_instance_profile.agent_profile.name}"
  description = "Name of the agent profile"
}

output "aws_agent_role" {
  value       = "${aws_iam_role.agent_role.name}"
  description = "Name of the agent role"
}

output "aws_master_profile" {
  value       = "${aws_iam_instance_profile.master_profile.name}"
  description = "Name of the masters profile"
}

output "aws_master_role" {
  value       = "${aws_iam_role.master_role.name}"
  description = "Name of the masters role"
}
