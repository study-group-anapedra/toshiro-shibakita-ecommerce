/*
  outputs.tf

  FUNÇÃO:
  Exportar recursos importantes.

  CI/CD pode validar instalação.
*/

output "alb_controller_installed" {

  value = helm_release.aws_load_balancer_controller.name

}