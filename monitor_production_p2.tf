// The following alerts are configured to monitor production performance levels
// When breached, NewRelic will use a Slack webhook to create an incident
// All alert conditions were created as critical even when they should be considered P2 warnings
// That's because NewRelic warnings don't generate incidents or send notifications

# MongoDB Critical
resource "newrelic_nrql_alert_condition" "apm_service_overview_web_mongo_db_warning" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_warning.id
  type                         = "static"
  name                         = "MongoDB response time anomaly (P2)"
  description                  = "MongoDB response time above 1ms for 10min"
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
    threshold             = 0.002 # 2ms
    threshold_duration    = 600   # 10 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# MySQL Critical
resource "newrelic_nrql_alert_condition" "apm_service_overview_web_mysql_warning" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_warning.id
  type                         = "static"
  name                         = "MySQL response time anomaly (P2)"
  description                  = "MySQL response time above 350ms for 5min"
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

  critical {
    operator              = "above"
    threshold             = 0.35 # 350ms (To avoid triggering when running project creation)
    threshold_duration    = 600  # 10 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# Elasticsearch Critical
resource "newrelic_nrql_alert_condition" "apm_service_overview_web_elasticsearch_warning" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_warning.id
  type                         = "static"
  name                         = "ElasticSearch response time anomaly (P2)"
  description                  = "ElasticSearch response time above 6.5ms for 15min"
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  expiration_duration          = 600   # 10 minutes
  violation_time_limit_seconds = 21600 # 6 hours in seconds
  open_violation_on_expiration = true
  fill_option                  = "none"


  nrql {
    query = "SELECT average(`apm.service.overview.web`) FROM Metric WHERE segmentName='Elasticsearch' AND appName='${var.production_app_name}'"
  }

  critical {
    operator              = "above"
    threshold             = 0.0065 # 6.5ms
    threshold_duration    = 900    # 15 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# Request Queuing Critical
resource "newrelic_nrql_alert_condition" "apm_service_overview_web_request_queuing_warning" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_warning.id
  type                         = "static"
  name                         = "Request Queuing time anomaly (P2)"
  description                  = "Request Queuing time above 50ms for 10min"
  enabled                      = true
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
    threshold             = 0.05 # 50ms
    threshold_duration    = 600  # 10 minutes in seconds
    threshold_occurrences = "ALL"
  }
}


resource "newrelic_nrql_alert_condition" "production_apdex_warning" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.production_performance_warning.id
  type                         = "static"
  name                         = "Apdex Score below 0.7 for 5 min (P2)"
  description                  = "Apdex score below 0.7 for 5 minutes."
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
    threshold             = 0.7
    threshold_duration    = 300
    threshold_occurrences = "ALL"
  }
}

# Elevated global error rates
resource "newrelic_nrql_alert_condition" "elevated_global_error_rates" {
  account_id = var.newrelic_account_id
  policy_id  = newrelic_alert_policy.production_performance_warning.id
  type       = "static"
  name       = "Elevated global error rates (web and Celery included)"

  description = trimspace(<<-EOT
  When this alert fires, take a look at the Errors Inbox in New Relic for more information.
  EOT
  )

  enabled                      = true
  violation_time_limit_seconds = 259200
  fill_option                  = "none"
  aggregation_window           = 60
  aggregation_method           = "event_flow"
  aggregation_delay            = 0

  nrql {
    query = "SELECT sum(apm.service.error.count['count']) / count(apm.service.transaction.duration) as 'Error rate' FROM Metric WHERE appName='${var.production_app_name}'"
  }

  critical {
    operator              = "above"
    threshold             = 0.00005
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

}

# Failed creation of submission Follow-up Actions
resource "newrelic_nrql_alert_condition" "follow_up_action_creation_failure" {
  account_id = var.newrelic_account_id
  policy_id  = newrelic_alert_policy.production_performance_warning.id
  type       = "static"
  name       = "Follow-up action creation by submission failed silently"

  description = trimspace(<<-EOT
  Resubmitting the associated submission will rerun the failed follow-up actions.
  EOT
  )

  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 120
  expiration_duration          = 300 # 5 minutes
  violation_time_limit_seconds = 600
  fill_option                  = "none"

  nrql {
    query = "SELECT count(*) FROM Log WHERE extra.fua_data is NOT NULL AND entity.name='${var.production_app_name}'"
  }

  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300 # 5 minutes in seconds
    threshold_occurrences = "ALL"
  }

}

resource "newrelic_nrql_alert_condition" "porter_worker_killed_run_out_of_memory_warning" {
  account_id = var.newrelic_account_id
  policy_id  = newrelic_alert_policy.production_performance_warning.id
  type       = "static"
  name       = "P2 - Porter worker killed after running out of memory"

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
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "all"
  }

}
