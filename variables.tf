variable "project" {
  description = "Nom du projet"
  type        = string
  default     = "azurevm"
}

variable "env" {
  description = "Environnement (dev/prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Région Azure"
  type        = string
  default     = "Italy North"
}

variable "admin_username" {
  description = "Nom d'utilisateur admin pour la VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Chemin vers la clé publique SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}