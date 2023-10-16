import 'dart:ffi';
import 'dart:io';

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

  // TODO(dacoharkes): Support `addressOf` for `@Native`s.
  // https://github.com/dart-lang/sdk/issues/50552
  static final _dylib = (Platform.isMacOS || Platform.isIOS)
      ? DynamicLibrary.process()
      : DynamicLibrary.open('libtest_hot_restart.so'); // Android & Linux

  static final _finalizer = NativeFinalizer(
      _dylib.lookup<NativeFinalizerFunction>('ReleaseResource'));

  static int allocatedCounter() => bindings.AllocatedCounter();
}
