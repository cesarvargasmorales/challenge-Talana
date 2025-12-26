# Challenge Talana – CI/CD – GitHub Actions
## Tabla de Contenidos
1.  [Visión General](#vision-general)
2.  [Workflow de Infraestructura](#workflow-de-infraestructura)
3.  [Workflow de Aplicación](#workflow-de-aplicacion)
4.  [Autenticación y Seguridad](#autenticacion-y-seguridad)
5.  [Variables y Secrets](#variables-y-secrets)

------------------------------------------------------------------------
## 1. Visión General
La separación en dos pipelines permite:

- Aislar cambios de infraestructura y aplicación
- Reducir riesgos en despliegues
- Aplicar el principio least privilege
- Facilitar rollback y troubleshooting
- Escalar a múltiples entornos (dev / qa / prod)

Cada workflow se ejecuta solo cuando es necesario, según los cambios en el repositorio.

------------------------------------------------------------------------
## 2. Workflow de Infraestructura

Archivo:
```bash
.github/workflows/infra.yaml
```

Responsabilidad

Este workflow despliega y mantiene la infraestructura en GCP utilizando Terraform.

Acciones principales

- Autenticación en GCP mediante Workload Identity Federation
- Inicialización de Terraform
- ```terraform plan``` 
- ```terraform apply```

Recursos gestionados

- VPC y subredes
- GKE Cluster
- Cloud SQL (PostgreSQL con IP privada)
- Artifact Registry
- IAM / Service Accounts
- Workload Identity
- Private Service Access

Cuándo se ejecuta

- Cambios en el directorio infra/
- Ejecución manual (workflow_dispatch)
------------------------------------------------------------------------
## 3. Workflow de Aplicación

Archivo:
```bash
.github/workflows/deploy-app.yaml
```

Responsabilidad

Este workflow construye y despliega la aplicación Django en GKE.

Acciones principales

- Autenticación en GCP vía Workload Identity
- Build de la imagen Docker
- Push a Artifact Registry
- Obtención de credenciales del cluster GKE
- Aplicación de manifiestos Kubernetes (kubectl apply)

Componentes desplegados

- Deployment (Django + Cloud SQL Auth Proxy)
- Service
- Gateway API
- HTTPRoute
- Namespace y Secrets (si no existen)

Cuándo se ejecuta

- Cambios en el directorio ```django/```
- Cambios en el directorio ```deployment/```
- Ejecución manual (```workflow_dispatch```)
------------------------------------------------------------------------
## 4.Autenticación y Seguridad

Ambos workflows utilizan Workload Identity Federation, eliminando el uso de claves JSON.

Características clave:

- Autenticación OIDC desde GitHub Actions
- Impersonación de Service Accounts en GCP
- Roles mínimos necesarios por workflow
- Acceso a GKE y Secret Manager sin credenciales estáticas

Esto mejora significativamente la postura de seguridad del pipeline.

------------------------------------------------------------------------

## 5. GitHub Secrets
| Nombre            | Descripción                              |
|-------------------|------------------------------------------|
| `GCP_WIF_PROVIDER`| Workload Identity Provider               |
| `GCP_DEPLOY_SA`   | Service Account usado por los workflows  |

| Nombre             | Descripción               |
|--------------------|---------------------------|
| `GCP_PROJECT_ID`   | ID del proyecto GCP       |
| `GCP_REGION`       | Región principal          |
| `GKE_CLUSTER_NAME` | Nombre del cluster GKE    |