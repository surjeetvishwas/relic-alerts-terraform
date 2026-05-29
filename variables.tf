variable "newrelic_account_id" {
  description = "New Relic account ID used by alert conditions."
  type        = number
}

variable "newrelic_api_key" {
  description = "New Relic user API key used by the provider."
  type        = string
  sensitive   = true
}

variable "production_app_name" {
  description = "New Relic APM application name for production."
  type        = string
}

variable "production_cluster_name" {
  description = "Kubernetes cluster name used by production workloads."
  type        = string
}

variable "heartbeat_slack_nr_channel_id" {
  description = "New Relic alert channel ID for Slack heartbeat notifications."
  type        = number
}

variable "ops_genie_nr_channel_id" {
  description = "New Relic alert channel ID for OpsGenie notifications."
  type        = number
}

variable "kubernetes_alert_policy_id" {
  description = "New Relic alert policy ID for Kubernetes alerts."
  type        = number
}

variable "sensors_runbook_url" {
  description = "Runbook URL used by sensor queue alerts."
  type        = string
}

variable "nightly_queue_runbook_url" {
  description = "Runbook URL used by nightly queue alerts."
  type        = string
}

variable "name_suffix" {
  description = "Suffix added to New Relic policy and alert names to avoid naming conflicts."
  type        = string
  default     = "beta1"
}
