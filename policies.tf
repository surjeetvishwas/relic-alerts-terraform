resource "newrelic_alert_policy" "sensors_queue_critial" {
  name                = "Sensors queue - RabbitMQ number of messages = 0 for the last 15min${local.name_suffix_label}"
  incident_preference = "PER_POLICY"

  channel_ids = [
    var.ops_genie_nr_channel_id,
  ]
}

resource "newrelic_alert_policy" "sensors_queue_warning" {
  name                = "Sensors queue - RabbitMQ number of messages > 100 for the last 15-20min${local.name_suffix_label}"
  incident_preference = "PER_POLICY"

  channel_ids = [
    var.heartbeat_slack_nr_channel_id,
  ]
}

resource "newrelic_alert_policy" "fivetran_logs_warning" {
  name                = "Fivetran logs warning${local.name_suffix_label}"
  incident_preference = "PER_POLICY"

  channel_ids = [
    var.heartbeat_slack_nr_channel_id,
  ]
}

resource "newrelic_alert_policy" "production_performance_critical" {
  name                = "Production Performance Critical${local.name_suffix_label}"
  incident_preference = "PER_POLICY"

  channel_ids = [
    var.ops_genie_nr_channel_id,
  ]
}

resource "newrelic_alert_policy" "production_performance_warning" {
  name                = "Production Performance Warning (P2)${local.name_suffix_label}"
  incident_preference = "PER_CONDITION"

  channel_ids = [
    var.heartbeat_slack_nr_channel_id,
  ]
}
