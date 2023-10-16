#include "test_hot_restart.h"
#include <assert.h>

void* global_resource = NULL;
int allocated_counter = 0;

FFI_PLUGIN_EXPORT void* AllocateResource() {
  assert(global_resource == NULL);
  global_resource = malloc(20);
  allocated_counter++;
  return global_resource;
}

FFI_PLUGIN_EXPORT void ReleaseResource(void* resource) {
  printf("Releasing Resource.\n");
  free(resource);
  global_resource = NULL;
  allocated_counter--;
}

FFI_PLUGIN_EXPORT int AllocatedCounter() {
  return allocated_counter;
}
