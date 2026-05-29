// The following alerts are configured to monitor production performance levels
// When breached, NewRelic will use the PagerDuty webhook to create a P1 incident

# MongoDB Critical
resource "newrelic_nrql_alert_condition" "apm_service_overview_web_mongo_db_critical" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_critical.id
  type                         = "static"
  name                         = "MongoDB response time anomaly"
  description                  = "MongoDB response time above 5ms for 15min"
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  expiration_duration          = 300   # 5 minutes
  violation_time_limit_seconds = 21600 # 6 hours in seconds
  open_violation_on_expiration = true
  fill_option                  = "none"


  nrql {
    query = "SELECT average(`apm.service.overview.web`) FROM Metric WHERE segmentName='MongoDB' AND appName='${var.production_app_name}'"
  }

  critical {
    operator              = "above"
    threshold             = 0.005 # 5ms
    threshold_duration    = 900   # 15 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# MySQL Critical
resource "newrelic_nrql_alert_condition" "apm_service_overview_web_mysql_critical" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_critical.id
  type                         = "static"
  name                         = "MySQL response time anomaly"
  description                  = "MySQL response time above 500ms for 10min"
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  expiration_duration          = 300   # 5 minutes
  violation_time_limit_seconds = 21600 # 6 hours in seconds
  open_violation_on_expiration = true
  fill_option                  = "none"


  nrql {
    query = "SELECT average(`apm.service.overview.web`) FROM Metric WHERE segmentName='MySQL' AND appName='${var.production_app_name}'"
  }
  // ToDo add a mute rule in NewRelic to handle the task generation spike an set a better value for the threshold
  critical {
    operator              = "above"
    threshold             = 0.5 # 500ms
    threshold_duration    = 600 # 10 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# Elasticsearch Critical
resource "newrelic_nrql_alert_condition" "apm_service_overview_web_elasticsearch_critical" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_critical.id
  type                         = "static"
  name                         = "ElasticSearch response time anomaly"
  description                  = "ElasticSearch response time above 15ms for 10min"
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  expiration_duration          = 300   # 5 minutes
  violation_time_limit_seconds = 21600 # 6 hours in seconds
  open_violation_on_expiration = true
  fill_option                  = "none"


  nrql {
    query = "SELECT average(`apm.service.overview.web`) FROM Metric WHERE segmentName='Elasticsearch' AND appName='${var.production_app_name}'"
  }

  critical {
    operator              = "above"
    threshold             = 0.015 # 15ms
    threshold_duration    = 600   # 10 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# Request Queuing Critical
resource "newrelic_nrql_alert_condition" "apm_service_overview_web_request_queuing_critical" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_critical.id
  type                         = "static"
  name                         = "Request Queuing time anomaly"
  description                  = "Request Queuing time above 100ms for 10min"
  enabled                      = false
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  expiration_duration          = 300   # 5 minutes
  violation_time_limit_seconds = 21600 # 6 hours in seconds
  open_violation_on_expiration = true
  fill_option                  = "none"


  nrql {
    query = "SELECT average(`apm.service.request.queuing`) FROM Metric WHERE appName='${var.production_app_name}'"
  }

  critical {
    operator              = "above"
    threshold             = 0.1 # 100ms
    threshold_duration    = 600 # 10 minutes in seconds
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_nrql_alert_condition" "production_apdex_critical" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_critical.id
  type                         = "static"
  name                         = "Apdex Score below 0.65 for 8min"
  description                  = "Apdex score below 0.65 for 8 minutes."
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 120
  expiration_duration          = 300
  violation_time_limit_seconds = 21600
  open_violation_on_expiration = true
  fill_option                  = "none"

  nrql {
    query = "SELECT apdex(duration, t: 0.5) FROM Transaction WHERE appName='${var.production_app_name}'"
  }

  critical {
    operator              = "below"
    threshold             = 0.65
    threshold_duration    = 480
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_nrql_alert_condition" "sso_errors_during_login_redirect" {
  account_id = var.newrelic_account_id
  policy_id  = newrelic_alert_policy.production_performance_critical.id
  type       = "static"
  name       = "SSO errors during login redirect"

  description = "SSO failures over a 5 minute time period"

  enabled                      = true
  violation_time_limit_seconds = 21600 # 6 hours in seconds
  fill_option                  = "none"
  aggregation_window           = 300
  aggregation_method           = "event_flow"
  aggregation_delay            = 120

  nrql {
    query = "select count(*) FROM Transaction where appName='${var.production_app_name}' and `request.uri` like '%saml2%' and response.status = '500' and name = 'WebTransaction/Function/djangosaml2.views:LoginView.get'"
  }

  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

}

resource "newrelic_nrql_alert_condition" "porter_worker_killed_run_out_of_memory_critical" {
  account_id = var.newrelic_account_id
  policy_id  = newrelic_alert_policy.production_performance_critical.id
  type       = "static"
  name       = "Porter worker killed after running out of memory"

  description = "One or more Porter instances has been killed after running out of memory. If this incident is critical look into changing the size/scaling of the Porter instance, or the MAX_MEMORY_PER_NODE and MAX_TASKS_PER_NODE for the worker. For now more information can be found here `scripts/launch_worker.sh`"

  enabled                      = true
  violation_time_limit_seconds = 10800 # 3 hours in seconds
  fill_option                  = "none"
  aggregation_window           = 60
  aggregation_method           = "event_flow"
  aggregation_delay            = 120

  nrql {
    query = "FROM K8sContainerSample select uniqueCount(lastTerminatedTimestamp) where clusterName ='${var.production_cluster_name}' and lastTerminatedExitCode = 137 and `label.porter.run/service-name` is NOT NULL and `label.porter.run/app-name` = '${var.production_app_name}' facet `label.porter.run/service-name`"
  }

  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 60
    threshold_occurrences = "all"
  }

}
