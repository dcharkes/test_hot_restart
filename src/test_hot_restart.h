#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

FFI_PLUGIN_EXPORT void* AllocateResource();

FFI_PLUGIN_EXPORT void ReleaseResource(void* resource);

FFI_PLUGIN_EXPORT int AllocatedCounter();
