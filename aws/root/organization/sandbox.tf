resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "${var.organization}-ou-root-sandbox"
  parent_id = aws_organizations_organizational_unit.root.id
}