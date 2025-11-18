variable "vm_name" {
  type        = string
  description = "Имя виртуальной машины"
}

variable "cores" {
  type        = number
  description = "Количество vCPU"
}

variable "memory" {
  type        = number
  description = "Объем RAM в гигабайтах"
}

variable "disk_size" {
  type        = number
  description = "Размер диска в гигабайтах"
}

variable "subnet_id" {
  type        = string
  description = "ID подсети"
}

variable "ssh_public_key" {
  type        = string
  description = "Публичный SSH ключ"
}
