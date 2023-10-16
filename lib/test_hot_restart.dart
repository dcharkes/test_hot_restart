import 'dart:ffi';

import 'test_hot_restart_bindings_generated.dart' as bindings;

class MyResource implements Finalizable {
  final Pointer<Void> _pointer;

  bool _released = false;

  MyResource._(this._pointer);

  factory MyResource.allocate() {
    final pointer = bindings.AllocateResource();
    final result = MyResource._(pointer);
    _finalizer.attach(result, pointer);
    return result;
  }

  void release() {
    if (_released) {
      return;
    }
    _released = true;
    _finalizer.detach(this);
    bindings.ReleaseResource(_pointer);
  }

  // static final _dylib = DynamicLibrary.open('libtest_hot_restart.so'); // Android
  static final _dylib = DynamicLibrary.process(); // MacOS

  static final _finalizer = NativeFinalizer(
      _dylib.lookup<NativeFinalizerFunction>('ReleaseResource'));

  static int allocatedCounter() => bindings.AllocatedCounter();
}
