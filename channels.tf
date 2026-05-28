resource "newrelic_alert_channel" "devops" {
  name = "Zenput DevOps"
  type = "email"

  config {
    recipients              = "devops@zenput.com"
    include_json_attachment = "true"
  }
}

resource "newrelic_alert_channel" "devops-nonprod" {
  name = "Zenput DevOps - Non Production"
  type = "email"

  config {
    recipients              = "devops+nonproduction@zenput.com"
    include_json_attachment = "true"
  }
}
