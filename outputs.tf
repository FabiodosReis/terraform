output "vpc" {
  value = {
    id = module.network.vpc.id
    arn = module.network.vpc.arn
    cidr_block = module.network.vpc.cidr_block
  }
}

output "subnets" {
  value = {
    private = {
      id         = module.network.subnets.private.*.id
      cidr_block = module.network.subnets.private.*.cidr_block
    }
    public = {
      id         = module.network.subnets.public.*.id
      cidr_block = module.network.subnets.public.*.cidr_block
    }
  }
}

output "sg_alb" {
  value = {
    id = module.sg.sg_alb.id
  }
}

output "sg_app" {
  value = {
    id = module.sg.sg_app.id
  }
}

output "role" {
  value = {
    ecs_execution_role = module.iam.ecs_execution_role
    task_executon_role = module.iam.task_execution_role
  }
}