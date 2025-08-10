data "aws_availability_zones" "zones" {}

locals {

  sorted_vailability_zones   = sort(data.aws_availability_zones.zones.names)
  selected_vailability_zones = slice(local.sorted_vailability_zones, 0, var.network.az_count)

}