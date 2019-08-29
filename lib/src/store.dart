import "dart:ffi";

import "bindings/bindings.dart";
import "bindings/helpers.dart";

import "model.dart";

class Store {
    Pointer<Void> _objectboxStore;

    Store(Model model) {
        var opt = bindings.obx_opt();
        bindings.obx_opt_model(opt, model.ptr);
        _objectboxStore = bindings.obx_store_open(opt);
        check(_objectboxStore != null);
    }

    close() {
        checkObx(bindings.obx_store_close(_objectboxStore));
    }

    get ptr => _objectboxStore;
}