# Fivetran Logs Error Critical
resource "newrelic_nrql_alert_condition" "fivetran_logs_failed_warning" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.fivetran_logs_warning.id
  type                         = "static"
  name                         = "Fivetran logs error anomaly"
  description                  = "Fivetran logs returned an error on the mongo_production connector"
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  expiration_duration          = 300   # 5 minutes
  violation_time_limit_seconds = 21600 # 6 hours in seconds
  open_violation_on_expiration = true
  fill_option                  = "none"


  nrql {
    query = "SELECT count(*) FROM Log where logger = 'Fivetran' and data.status in ('FAILURE', 'FAILURE_WITH_TASK') and connector_name in ('mongo_production', 'zenput_production_mongo_biziq')"
  }

  critical {
    operator              = "above"
    threshold             = 0    # 0 errors
    threshold_duration    = 3600 # 1 hour in seconds
    threshold_occurrences = "AT_LEAST_ONCE"
  }
}

resource "newrelic_nrql_alert_condition" "fivetran_logs_failed_warning_mysql" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.fivetran_logs_warning.id
  type                         = "static"
  name                         = "Fivetran logs error anomaly"
  description                  = "Fivetran logs returned an error on the mysql_rds_production_2 connector or zenput_production_mysql_biziq connector"
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  expiration_duration          = 300 # 5 minutes
  violation_time_limit_seconds = 900 # 15 minutes in seconds
  open_violation_on_expiration = true
  fill_option                  = "none"


  nrql {
    query = "SELECT count(*) FROM Log where logger = 'Fivetran' and data.status in ('FAILURE', 'FAILURE_WITH_TASK') and connector_name in ('mysql_rds_production_2','zenput_production_mysql_biziq')  "
  }

  critical {
    operator              = "above"
    threshold             = 0   # 0 errors
    threshold_duration    = 900 # 15 minutes in seconds
    threshold_occurrences = "AT_LEAST_ONCE"
  }
}

resource "newrelic_nrql_alert_condition" "no_logs_from_fivetran_in_the_last_time_period" {
  account_id = var.newrelic_account_id
  policy_id  = newrelic_alert_policy.fivetran_logs_warning.id
  type       = "static"
  name       = "No logs from Fivetran in the last time period"

  description = trimspace(<<-EOT
  Fivetran has not logged any updates in the preceding time period. Check that Fivetran is up and syncing
  GCP RDS Connector: https://fivetran.com/dashboard/connections/buck_scalp/status?groupId=fermented_skillful&service=mysql_rds&syncChartPeriod=1%20Day
  AWS RDS Connector: https://fivetran.com/dashboard/connections/impede_glasses/status?groupId=lens_repose&service=mysql_rds&syncChartPeriod=1%20Day
  EOT
  )

  runbook_url                  = "https://zenput.atlassian.net/wiki/spaces/DEV/pages/3184295966/Fivetran"
  enabled                      = true
  violation_time_limit_seconds = 86400 # 1 day
  fill_option                  = "none"
  aggregation_window           = 900 # 15 minutes
  aggregation_method           = "event_timer"
  aggregation_timer            = 60 # 1 minute


  nrql {
    query = "SELECT count(*) FROM Log where logger = 'Fivetran' and connector_name in ('mysql_rds_production_2','zenput_production_mysql_biziq') facet connector_name"
  }

  warning {
    operator              = "below"
    threshold             = 1
    threshold_duration    = 1800 # 30 minutes
    threshold_occurrences = "all"
  }

  critical {
    operator              = "below"
    threshold             = 1
    threshold_duration    = 3600 # 1 hour
    threshold_occurrences = "all"
  }
}
