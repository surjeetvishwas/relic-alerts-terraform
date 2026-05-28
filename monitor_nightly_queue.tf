#
# 2023-06-02 Turning off https://zenput.atlassian.net/browse/ZP-11609
#
# resource "newrelic_synthetics_monitor" "nightly_queue" {
#   name      = "Nightly Queue Sizes"
#   type      = "SCRIPT_API"
#   frequency = 1
#   status    = "ENABLED"
#   locations = ["AWS_US_EAST_2"]
# }

#
# 2023-06-02 Turning off https://zenput.atlassian.net/browse/ZP-11609
#
# resource "newrelic_synthetics_monitor_script" "nightly_queue" {
#   monitor_id = newrelic_synthetics_monitor.nightly_queue.id
#   text       = file("${path.module}/scripts/nightly_queue.js")
# }

#
# 2023-06-02 Turning off https://zenput.atlassian.net/browse/ZP-11609
#
# resource "newrelic_synthetics_alert_condition" "nightly-queue-sizes" {
#   policy_id = newrelic_alert_policy.devops.id

#   name        = "Nightly queue sizes"
#   monitor_id  = newrelic_synthetics_monitor_script.nightly_queue.id
#   runbook_url = var.nightly_queue_runbook_url
# }

#
# 2023-06-02 Turning off https://zenput.atlassian.net/browse/ZP-11609
#
# nightly_queue_still_high alert condition examines the calculated value
# of the queue after all processing should be complete. In this situation
# we expect the queue size to be below 500.
# resource "newrelic_nrql_alert_condition" "nightly_queue_still_high" {
#   account_id                   = var.newrelic_account_id
#   policy_id                    = newrelic_alert_policy.devops.id
#   type                         = "static"
#   name                         = "nightly queue still high"
#   description                  = "The queue is still high after processing nightly items"
#   runbook_url                  = var.nightly_queue_runbook_url
#   enabled                      = true
#   violation_time_limit_seconds = 604800 # One week in seconds
#   value_function               = "single_value"

#   fill_option = "LAST_VALUE"

#   aggregation_window             = 60
#   expiration_duration            = 120
#   open_violation_on_expiration   = true
#   close_violations_on_expiration = true

#   nrql {
#     query             = "SELECT max(lowAfter) FROM NightlyQueueCounts"
#     evaluation_offset = 5
#   }

#   critical {
#     operator              = "above"
#     threshold             = 500
#     threshold_duration    = 120
#     threshold_occurrences = "AT_LEAST_ONCE"
#   }
# }


#
# 2023-06-02 Turning off https://zenput.atlassian.net/browse/ZP-11609
#
# nightly_queue_too_low alert condition examines the calculated value of the
# queue when it should be populated with items to process. In this situation
# we expect there to be more than 100,000 items in the queue.
# resource "newrelic_nrql_alert_condition" "nightly_queue_too_low" {
#   account_id                   = var.newrelic_account_id
#   policy_id                    = newrelic_alert_policy.devops.id
#   type                         = "static"
#   name                         = "nightly queue too low"
#   description                  = "The queue is still too low when nightly items should be present"
#   runbook_url                  = var.nightly_queue_runbook_url
#   enabled                      = true
#   violation_time_limit_seconds = 604800 # One week in seconds
#   value_function               = "single_value"

#   fill_option = "LAST_VALUE"

#   aggregation_window             = 900
#   expiration_duration            = 900
#   open_violation_on_expiration   = true
#   close_violations_on_expiration = true

#   nrql {
#     query             = "SELECT max(highDuring) FROM NightlyQueueCounts"
#     evaluation_offset = 1
#   }

#   critical {
#     operator              = "below"
#     threshold             = 100000
#     threshold_duration    = 900
#     threshold_occurrences = "AT_LEAST_ONCE"
#   }
# }
