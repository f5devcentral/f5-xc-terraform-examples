locals {
  workload_name = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
}