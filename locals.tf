locals {
  name_suffix_label = trimspace(var.name_suffix) != "" ? " ${trimspace(var.name_suffix)}" : ""
}
