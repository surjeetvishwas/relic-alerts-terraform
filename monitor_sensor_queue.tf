# sensor_triggers_queue_low alert condition check if the sensortriggers queue
# is at 0 for more than 60 minutes
resource "newrelic_nrql_alert_condition" "sensor_triggers_queue_low" {
  account_id                     = var.newrelic_account_id
  policy_id                      = newrelic_alert_policy.sensors_queue_critial.id
  type                           = "static"
  name                           = "Sensor Triggers queue at 0 for 60 minutes${local.name_suffix_label}"
  description                    = "The queue is low for more than 60 minutes"
  runbook_url                    = var.sensors_runbook_url
  enabled                        = false
  aggregation_method             = "event_flow"
  aggregation_window             = 60
  aggregation_delay              = 60
  expiration_duration            = 900
  violation_time_limit_seconds   = 604800 # One week in seconds
  open_violation_on_expiration   = true
  close_violations_on_expiration = true
  fill_option                    = "none"


  nrql {
    query = "SELECT max(`rabbitmq.queue.messages`) FROM Metric WHERE instance_name = 'production' AND rabbitmq_queue = 'sensortriggers'"
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 3600 # 60 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# sensor_senet_queue_low alert condition check if the sensor senet queue
# is at 0 for more than 15 minutes
resource "newrelic_nrql_alert_condition" "sensor_senet_queue_low" {
  account_id                     = var.newrelic_account_id
  policy_id                      = newrelic_alert_policy.sensors_queue_critial.id
  type                           = "static"
  name                           = "Sensor Senet queue at 0 for 15 minutes${local.name_suffix_label}"
  description                    = "The queue is low for more than 15 minutes"
  runbook_url                    = var.sensors_runbook_url
  enabled                        = false
  aggregation_method             = "event_flow"
  aggregation_window             = 60
  aggregation_delay              = 60
  expiration_duration            = 900
  violation_time_limit_seconds   = 604800 # One week in seconds
  open_violation_on_expiration   = true
  close_violations_on_expiration = true
  fill_option                    = "none"

  nrql {
    query = "SELECT max(`rabbitmq.queue.messages`) FROM Metric WHERE instance_name = 'production' AND rabbitmq_queue = 'sensorsenetreadings'"
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 900 # 15 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# sensor_machineq_queue_low alert condition check if the sensor machineq queue delivery rate
# is at 0 for more than 30 minutes
resource "newrelic_nrql_alert_condition" "sensor_machineq_queue_low" {
  account_id                     = var.newrelic_account_id
  policy_id                      = newrelic_alert_policy.sensors_queue_critial.id
  type                           = "static"
  name                           = "Sensor MachineQ queue at 0 for 30 minutes${local.name_suffix_label}"
  description                    = "The queue is low for more than 30 minutes"
  runbook_url                    = var.sensors_runbook_url
  enabled                        = false
  aggregation_method             = "event_flow"
  aggregation_window             = 60
  aggregation_delay              = 60
  expiration_duration            = 900
  violation_time_limit_seconds   = 604800 # One week in seconds
  open_violation_on_expiration   = true
  close_violations_on_expiration = true
  fill_option                    = "none"

  nrql {
    query = "SELECT max(`rabbitmq.queue.messages.deliver.rate`) FROM Metric WHERE instance_name = 'production' AND rabbitmq_queue = 'sensormachineqreadings'"
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 1800 # 30 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# sensor_monnit_queue_low alert condition check if the sensor monnit queue
# is at 0 for more than 35 minutes
resource "newrelic_nrql_alert_condition" "sensor_monnit_queue_low" {
  account_id                     = var.newrelic_account_id
  policy_id                      = newrelic_alert_policy.sensors_queue_critial.id
  type                           = "static"
  name                           = "Sensor Monnit queue at 0 for 35 minutes${local.name_suffix_label}"
  description                    = "The queue is low for more than 35 minutes"
  runbook_url                    = var.sensors_runbook_url
  enabled                        = false
  aggregation_method             = "event_flow"
  aggregation_window             = 60
  aggregation_delay              = 60
  expiration_duration            = 2100
  violation_time_limit_seconds   = 604800 # One week in seconds
  open_violation_on_expiration   = true
  close_violations_on_expiration = true
  fill_option                    = "none"

  nrql {
    query = "SELECT max(`rabbitmq.queue.messages.deliver.rate`) FROM Metric WHERE instance_name = 'production' AND rabbitmq_queue = 'sensormonnitreadings'"
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 2100 # 35 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# sensor_deprecated_queue_low alert condition check if the sensor deprecated queue
# is at 0 for more than 2.5 hours
resource "newrelic_nrql_alert_condition" "sensor_deprecated_queue_low" {
  account_id                     = var.newrelic_account_id
  policy_id                      = newrelic_alert_policy.sensors_queue_critial.id
  type                           = "static"
  name                           = "Sensor Deprecated queue at 0 for 150 minutes${local.name_suffix_label}"
  description                    = "The queue is low for more than 150 minutes"
  runbook_url                    = var.sensors_runbook_url
  enabled                        = false
  aggregation_method             = "event_flow"
  aggregation_window             = 60
  aggregation_delay              = 60
  expiration_duration            = 900
  violation_time_limit_seconds   = 604800 # One week in seconds
  open_violation_on_expiration   = true
  close_violations_on_expiration = true
  fill_option                    = "none"

  nrql {
    query = "SELECT max(`rabbitmq.queue.messages`) FROM Metric WHERE instance_name = 'production' AND rabbitmq_queue = 'sensordeprecatedreadings'"
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 9000 # 150 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# sensor_triggers_queue_high alert condition check if the sensor triggers queue
# doesn't acknowledge more than 150 message in a period of 20 minutes
resource "newrelic_nrql_alert_condition" "sensor_triggers_queue_high" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.sensors_queue_warning.id
  type                         = "static"
  name                         = "Sensor Triggers queue above 150 messages${local.name_suffix_label}"
  description                  = "The queue is high for more than 20 minutes"
  runbook_url                  = var.sensors_runbook_url
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  violation_time_limit_seconds = 604800 # One week in seconds
  fill_option                  = "none"

  nrql {
    query = "SELECT average(`rabbitmq.queue.messages`) FROM Metric WHERE instance_name = 'production' AND rabbitmq_queue = 'sensortriggers'"
  }

  critical {
    operator              = "above"
    threshold             = 150
    threshold_duration    = 1200 # 20 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# sensor_senet_queue_high alert condition check if the sensor senet queue
# doesn't acknowledge more than 800 messages in a period of 20 minutes
resource "newrelic_nrql_alert_condition" "sensor_senet_queue_high" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.sensors_queue_warning.id
  type                         = "static"
  name                         = "Sensor Senet queue above 800 messages${local.name_suffix_label}"
  description                  = "The queue is high for more than 20 minutes"
  runbook_url                  = var.sensors_runbook_url
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  violation_time_limit_seconds = 604800 # One week in seconds
  fill_option                  = "none"

  nrql {
    query = "SELECT average(`rabbitmq.queue.messages`) FROM Metric WHERE instance_name = 'production' AND rabbitmq_queue = 'sensorsenetreadings'"
  }

  critical {
    operator              = "above"
    threshold             = 800
    threshold_duration    = 1200 # 20 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# sensor_machineq_queue_high alert condition check if the sensor machineq queue
# doesn't acknowledge more than 800 messages in a period of 20 minutes
resource "newrelic_nrql_alert_condition" "sensor_machineq_queue_high" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.sensors_queue_warning.id
  type                         = "static"
  name                         = "Sensor MachineQ queue above 800 messages${local.name_suffix_label}"
  description                  = "The queue is high for more than 20 minutes"
  runbook_url                  = var.sensors_runbook_url
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  violation_time_limit_seconds = 604800 # One week in seconds
  fill_option                  = "none"

  nrql {
    query = "SELECT average(`rabbitmq.queue.messages`) FROM Metric WHERE instance_name = 'production' AND rabbitmq_queue = 'sensormachineqreadings'"
  }

  critical {
    operator              = "above"
    threshold             = 800
    threshold_duration    = 1200 # 20 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# sensor_monnit_queue_high alert condition check if the sensor monnit queue
# doesn't acknowledge more than 800 messages in a period of 20 minutes
resource "newrelic_nrql_alert_condition" "sensor_monnit_queue_high" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.sensors_queue_warning.id
  type                         = "static"
  name                         = "Sensor Monnit queue above 800 messages${local.name_suffix_label}"
  description                  = "The queue is high for more than 20 minutes"
  runbook_url                  = var.sensors_runbook_url
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  violation_time_limit_seconds = 604800 # One week in seconds
  fill_option                  = "none"

  nrql {
    query = "SELECT average(`rabbitmq.queue.messages`) FROM Metric WHERE instance_name = 'production' AND rabbitmq_queue = 'sensormonnitreadings'"
  }

  critical {
    operator              = "above"
    threshold             = 800
    threshold_duration    = 1200 # 20 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

# sensor_deprecated_queue_high alert condition check if the sensor deprecated queue
# doesn't acknowledge more than 50 messages in a period of 15 minutes
resource "newrelic_nrql_alert_condition" "sensor_deprecated_queue_high" {
  account_id                   = var.newrelic_account_id
  policy_id                    = newrelic_alert_policy.sensors_queue_warning.id
  type                         = "static"
  name                         = "Sensor Deprecated queue above 50 messages.${local.name_suffix_label}"
  description                  = "The queue is high for more than 15 minutes."
  runbook_url                  = var.sensors_runbook_url
  enabled                      = true
  aggregation_method           = "event_flow"
  aggregation_window           = 60
  aggregation_delay            = 60
  violation_time_limit_seconds = 604800 # One week in seconds
  fill_option                  = "none"

  nrql {
    query = "SELECT average(`rabbitmq.queue.messages`) FROM Metric WHERE instance_name = 'production' AND rabbitmq_queue = 'sensordeprecatedreadings'"
  }

  critical {
    operator              = "above"
    threshold             = 50
    threshold_duration    = 900 # 15 minutes in seconds
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "sensor_machineq_api_calls" {
  account_id                     = var.newrelic_account_id
  policy_id                      = newrelic_alert_policy.sensors_queue_warning.id
  type                           = "static"
  name                           = "Sensor Event Readings (Monnit, MachineQ)${local.name_suffix_label}"
  description                    = "Sensor event readings endpoint not getting calls"
  runbook_url                    = var.sensors_runbook_url
  enabled                        = true
  aggregation_method             = "event_flow"
  aggregation_window             = 60
  aggregation_delay              = 120
  violation_time_limit_seconds   = 604800 # One week in seconds
  expiration_duration            = 3600
  fill_option                    = "none"
  open_violation_on_expiration   = true
  close_violations_on_expiration = true

  nrql {
    query = "SELECT COUNT(*) FROM Log WHERE extra.path_info = '/api/v2/sensors/event/reading/' AND entity.name = '${var.production_app_name}'"
  }

  critical {
    operator              = "equals"
    threshold             = 0
    threshold_duration    = 900 # 15 minutes in seconds
    threshold_occurrences = "ALL"
  }
}
