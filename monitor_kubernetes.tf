resource "newrelic_nrql_alert_condition" "container_is_running_out_of_space" {
  account_id                   = var.newrelic_account_id
  policy_id                    = var.kubernetes_alert_policy_id
  type                         = "static"
  name                         = "Container is running out of space"
  enabled                      = true
  violation_time_limit_seconds = 86400
  fill_option                  = "none"
  aggregation_window           = 60
  aggregation_method           = "event_flow"
  aggregation_delay            = 60

  nrql {
    query = "SELECT average(k8s.container.fsUsedPercent) FROM Metric WHERE metricName = 'k8s.container.fsUsedPercent' FACET entity.guid"
  }

  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }

  warning {
    operator              = "above"
    threshold             = 75
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}
