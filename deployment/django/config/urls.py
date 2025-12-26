from django.http import JsonResponse
from django.urls import path

def healthz(_request):
    return JsonResponse({"status": "ok"})

def readyz(_request):
    return JsonResponse({"status": "ready"})

urlpatterns = [
    path("healthz", healthz),
    path("readyz", readyz),
]
