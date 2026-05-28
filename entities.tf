data "newrelic_entity" "production_zenput" {
  name   = var.production_app_name
  type   = "APPLICATION"
  domain = "APM"
}
