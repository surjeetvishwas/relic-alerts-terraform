// Recommended baseline alerts that complement the existing service-specific
// monitors with broader application health coverage.

resource "newrelic_nrql_alert_condition" "production_web_latency_warning" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_warning.id
  type                         = "static"
  name                         = "Production web p95 latency high (P2)${local.name_suffix_label}"
  description                  = "The p95 web transaction duration is above 2 seconds for 15 minutes."
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 120
  expiration_duration          = 300
  violation_time_limit_seconds = 21600
  open_violation_on_expiration = true
  fill_option                  = "none"

  nrql {
    query = "SELECT percentile(duration, 95) FROM Transaction WHERE appName='${var.production_app_name}' AND name LIKE 'WebTransaction/%'"
  }

  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 900
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "production_web_error_rate_warning" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_warning.id
  type                         = "static"
  name                         = "Production web 5xx error rate high (P2)${local.name_suffix_label}"
  description                  = "The web transaction 5xx error rate is above 2% for 10 minutes."
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 120
  expiration_duration          = 300
  violation_time_limit_seconds = 21600
  open_violation_on_expiration = true
  fill_option                  = "none"

  nrql {
    query = "SELECT percentage(count(*), WHERE response.status LIKE '5%') FROM Transaction WHERE appName='${var.production_app_name}' AND name LIKE 'WebTransaction/%'"
  }

  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 600
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "production_web_traffic_missing_critical" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_critical.id
  type                         = "static"
  name                         = "Production web traffic missing${local.name_suffix_label}"
  description                  = "No web transactions were recorded for 15 minutes. This can indicate a full outage, broken ingress, or failed deployments."
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 120
  expiration_duration          = 300
  violation_time_limit_seconds = 21600
  open_violation_on_expiration = true
  fill_option                  = "none"

  nrql {
    query = "SELECT count(*) FROM Transaction WHERE appName='${var.production_app_name}' AND name LIKE 'WebTransaction/%'"
  }

  critical {
    operator              = "below"
    threshold             = 1
    threshold_duration    = 900
    threshold_occurrences = "ALL"
  }
}
