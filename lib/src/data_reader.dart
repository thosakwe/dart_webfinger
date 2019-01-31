FormatException _expected(String name, String expected, actual) {
  return FormatException(
      'Expected $name to be $expected; found $actual instead.');
}

/// Reads data from a [Map].
class MapReader {
  /// The [Map] to read from.
  final Map data;

  /// An optional name; typically used for subkeys.
  final String name;

  MapReader(this.data, {this.name});

  /// Finds a [List] with the given [name], and returns a [ListReader].
  ListReader listReader(String name,
      {bool allowNull = true, List Function() orElse}) {
    var v = readList(name, allowNull: allowNull, orElse: orElse);

    if (v != null) {
      return ListReader(v,
          name: this.name == null ? name : '${this.name}.$name');
    } else if (allowNull) {
      return null;
    }

    if (this.name != null) name = '${this.name}.$name';
    throw _expected(name, 'a list', v);
  }

  /// Attempts to read a [List].
  List readList(String name, {bool allowNull = true, List Function() orElse}) {
    var value = data[name];

    if (value == null) {
      if (orElse != null)
        return orElse();
      else if (allowNull) return null;
    } else if (value is List) {
      return value;
    } else if (value is Iterable) {
      return value.toList();
    }

    if (this.name != null) name = '${this.name}.$name';
    throw _expected(name, 'a list', value);
  }

  /// Finds a [Map] with the given [name], and returns a [MapReader].
  MapReader mapReader(String name,
      {bool allowNull = true, Map Function() orElse}) {
    var v = readMap(name, allowNull: allowNull, orElse: orElse);

    if (v != null) {
      return MapReader(v,
          name: this.name == null ? name : '${this.name}.$name');
    } else if (allowNull) {
      return null;
    }

    if (this.name != null) name = '${this.name}.$name';
    throw _expected(name, 'a map', v);
  }

  /// Attempts to read a [Map].
  Map readMap(String name, {bool allowNull = true, Map Function() orElse}) {
    var value = data[name];

    if (value == null) {
      if (orElse != null)
        return orElse();
      else if (allowNull) return null;
    } else if (value is Map) {
      return value;
    }

    if (this.name != null) name = '${this.name}.$name';
    throw _expected(name, 'a map', value);
  }

  /// Attempts to read a [Uri].
  Uri readUri(String name, {bool allowNull = true, Uri Function() orElse}) {
    var s = readString(name,
        allowNull: allowNull,
        orElse: orElse == null ? null : () => orElse().toString());

    if (s != null) {
      return Uri.parse(s);
    } else if (allowNull) {
      return null;
    }

    if (this.name != null) name = '${this.name}.$name';
    throw _expected(name, 'a URI', s);
  }

  /// Attempts to read a [String].
  String readString(String name,
      {bool allowNull = true, String Function() orElse}) {
    var value = data[name];

    if (value == null) {
      if (orElse != null)
        return orElse();
      else if (allowNull) return null;
    } else if (value is String) {
      return value;
    }

    if (this.name != null) name = '${this.name}.$name';
    throw _expected(name, 'a string', value);
  }
}

/// Reads data from a [List].
class ListReader {
  /// The [List] to read from.
  final List data;

  /// An optional name; typically used for subkeys.
  final String name;

  ListReader(this.data, {this.name});

  /// Finds a [Map] with the given [index], and returns a [MapReader].
  MapReader mapReader(int index,
      {bool allowNull = true, Map Function() orElse}) {
    var v = readMap(index, allowNull: allowNull, orElse: orElse);

    if (v != null) {
      return MapReader(v,
          name: this.name == null ? index : '${this.name}.$index');
    } else if (allowNull) {
      return null;
    }

    var name = index.toString();
    if (this.name != null) name = '${this.name}.$name';
    throw _expected(name, 'a map', v);
  }

  /// Attempts to read a [Map].
  Map readMap(int index, {bool allowNull = true, Map Function() orElse}) {
    var value = data[index];

    if (value == null) {
      if (orElse != null)
        return orElse();
      else if (allowNull) return null;
    } else if (value is Map) {
      return value;
    }

    var name = index.toString();
    if (this.name != null) name = '${this.name}.$name';
    throw _expected(name, 'a map', value);
  }
}
