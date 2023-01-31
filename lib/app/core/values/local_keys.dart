class LocalKeys {
  static final LocalKeys _singleton = LocalKeys._internal();

  factory LocalKeys() {
    return _singleton;
  }
  LocalKeys._internal();
}
