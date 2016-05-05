// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of dart._internal;

/**
 * Marker interface for [Iterable] subclasses that have an efficient
 * [length] implementation.
 */
abstract class EfficientLength {
  /**
   * Returns the number of elements in the iterable.
   *
   * This is an efficient operation that doesn't require iterating through
   * the elements.
   */
  int get length;
}

/**
 * An [Iterable] for classes that have efficient [length] and [elementAt].
 *
 * All other methods are implemented in terms of [length] and [elementAt],
 * including [iterator].
 */
abstract class ListIterable<E> extends Iterable<E>
                               implements EfficientLength {
  int get length;
  E elementAt(int i);

  const ListIterable();

  Iterator<E> get iterator => new ListIterator<E>(this);

  void forEach(void action(E element)) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      action(elementAt(i));
      if (length != this.length) {
        throw new ConcurrentModificationError(this);
      }
    }
  }

  bool get isEmpty => length == 0;

  E get first {
    if (length == 0) throw IterableElementError.noElement();
    return elementAt(0);
  }

  E get last {
    if (length == 0) throw IterableElementError.noElement();
    return elementAt(length - 1);
  }

  E get single {
    if (length == 0) throw IterableElementError.noElement();
    if (length > 1) throw IterableElementError.tooMany();
    return elementAt(0);
  }

  bool contains(Object element) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      if (elementAt(i) == element) return true;
      if (length != this.length) {
        throw new ConcurrentModificationError(this);
      }
    }
    return false;
  }

  bool every(bool test(E element)) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      if (!test(elementAt(i))) return false;
      if (length != this.length) {
        throw new ConcurrentModificationError(this);
      }
    }
    return true;
  }

  bool any(bool test(E element)) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      if (test(elementAt(i))) return true;
      if (length != this.length) {
        throw new ConcurrentModificationError(this);
      }
    }
    return false;
  }

  E firstWhere(bool test(E element), { E orElse() }) {
    int length = this.length;
    for (int i = 0; i < length; i++) {
      E element = elementAt(i);
      if (test(element)) return element;
      if (length != this.length) {
        throw new ConcurrentModificationError(this);
      }
    }
    if (orElse != null) return orElse();
    throw IterableElementError.noElement();
  }

  E lastWhere(bool test(E element), { E orElse() }) {
    int length = this.length;
    for (int i = length - 1; i >= 0; i--) {
      E element = elementAt(i);
      if (test(element)) return element;
      if (length != this.length) {
        throw new ConcurrentModificationError(this);
      }
    }
    if (orElse != null) return orElse();
    throw IterableElementError.noElement();
  }

  E singleWhere(bool test(E element)) {
    int length = this.length;
    E match = null;
    bool matchFound = false;
    for (int i = 0; i < length; i++) {
      E element = elementAt(i);
      if (test(element)) {
        if (matchFound) {
          throw IterableElementError.tooMany();
        }
        matchFound = true;
        match = element;
      }
      if (length != this.length) {
        throw new ConcurrentModificationError(this);
      }
    }
    if (matchFound) return match;
    throw IterableElementError.noElement();
  }

  String join([String separator = ""]) {
    int length = this.length;
    if (!separator.isEmpty) {
      if (length == 0) return "";
      String first = "${elementAt(0)}";
      if (length != this.length) {
        throw new ConcurrentModificationError(this);
      }
      StringBuffer buffer = new StringBuffer(first);
      for (int i = 1; i < length; i++) {
        buffer.write(separator);
        buffer.write(elementAt(i));
        if (length != this.length) {
          throw new ConcurrentModificationError(this);
        }
      }
      return buffer.toString();
    } else {
      StringBuffer buffer = new StringBuffer();
      for (int i = 0; i < length; i++) {
        buffer.write(elementAt(i));
        if (length != this.length) {
          throw new ConcurrentModificationError(this);
        }
      }
      return buffer.toString();
    }
  }

  Iterable<E> where(bool test(E element)) => super.where(test);

  Iterable/*<T>*/ map/*<T>*/(/*=T*/ f(E element)) =>
      new MappedListIterable<E, dynamic/*=T*/ >(this, f);

  E reduce(E combine(var value, E element)) {
    int length = this.length;
    if (length == 0) throw IterableElementError.noElement();
    E value = elementAt(0);
    for (int i = 1; i < length; i++) {
      value = combine(value, elementAt(i));
      if (length != this.length) {
        throw new ConcurrentModificationError(this);
      }
    }
    return value;
  }

  /*=T*/ fold/*<T>*/(
      var/*=T*/ initialValue, /*=T*/ combine(
          var/*=T*/ previousValue, E element)) {
    var value = initialValue;
    int length = this.length;
    for (int i = 0; i < length; i++) {
      value = combine(value, elementAt(i));
      if (length != this.length) {
        throw new ConcurrentModificationError(this);
      }
    }
    return value;
  }

  Iterable<E> skip(int count) => new SubListIterable<E>(this, count, null);

  Iterable<E> skipWhile(bool test(E element)) => super.skipWhile(test);

  Iterable<E> take(int count) => new SubListIterable<E>(this, 0, count);

  Iterable<E> takeWhile(bool test(E element)) => super.takeWhile(test);

  List<E> toList({bool growable: true}) {
    List<E> result;
    if (growable) {
      result = new List<E>()..length = length;
    } else {
      result = new List<E>(length);
    }
    for (int i = 0; i < length; i++) {
      result[i] = elementAt(i);
    }
    return result;
  }

  Set<E> toSet() {
    Set<E> result = new Set<E>();
    for (int i = 0; i < length; i++) {
      result.add(elementAt(i));
    }
    return result;
  }
}

class SubListIterable<E> extends ListIterable<E> {
  final Iterable<E> _iterable; // Has efficient length and elementAt.
  final int _start;
  /** If null, represents the length of the iterable. */
  final int _endOrLength;

  SubListIterable(this._iterable, this._start, this._endOrLength) {
    RangeError.checkNotNegative(_start, "start");
    if (_endOrLength != null) {
      RangeError.checkNotNegative(_endOrLength, "end");
      if (_start > _endOrLength) {
        throw new RangeError.range(_start, 0, _endOrLength, "start");
      }
    }
  }

  int get _endIndex {
    int length = _iterable.length;
    if (_endOrLength == null || _endOrLength > length) return length;
    return _endOrLength;
  }

  int get _startIndex {
    int length = _iterable.length;
    if (_start > length) return length;
    return _start;
  }

  int get length {
    int length = _iterable.length;
    if (_start >= length) return 0;
    if (_endOrLength == null || _endOrLength >= length) {
      return length - _start;
    }
    return _endOrLength - _start;
  }

  E elementAt(int index) {
    int realIndex = _startIndex + index;
    if (index < 0 || realIndex >= _endIndex) {
      throw new RangeError.index(index, this, "index");
    }
    return _iterable.elementAt(realIndex);
  }

  Iterable<E> skip(int count) {
    RangeError.checkNotNegative(count, "count");
    int newStart = _start + count;
    if (_endOrLength != null && newStart >= _endOrLength) {
      return new EmptyIterable<E>();
    }
    return new SubListIterable<E>(_iterable, newStart, _endOrLength);
  }

  Iterable<E> take(int count) {
    RangeError.checkNotNegative(count, "count");
    if (_endOrLength == null) {
      return new SubListIterable<E>(_iterable, _start, _start + count);
    } else {
      int newEnd = _start + count;
      if (_endOrLength < newEnd) return this;
      return new SubListIterable<E>(_iterable, _start, newEnd);
    }
  }

  List<E> toList({bool growable: true}) {
    int start = _start;
    int end = _iterable.length;
    if (_endOrLength != null && _endOrLength < end) end = _endOrLength;
    int length = end - start;
    if (length < 0) length = 0;
    List<E> result = growable ? (new List<E>()..length = length)
                              : new List<E>(length);
    for (int i = 0; i < length; i++) {
      result[i] = _iterable.elementAt(start + i);
      if (_iterable.length < end) throw new ConcurrentModificationError(this);
    }
    return result;
  }
}

/**
 * An [Iterator] that iterates a list-like [Iterable].
 *
 * All iterations is done in terms of [Iterable.length] and
 * [Iterable.elementAt]. These operations are fast for list-like
 * iterables.
 */
class ListIterator<E> implements Iterator<E> {
  final Iterable<E> _iterable;
  final int _length;
  int _index;
  E _current;

  ListIterator(Iterable<E> iterable)
      : _iterable = iterable, _length = iterable.length, _index = 0;

  E get current => _current;

  bool moveNext() {
    int length = _iterable.length;
    if (_length != length) {
      throw new ConcurrentModificationError(_iterable);
    }
    if (_index >= length) {
      _current = null;
      return false;
    }
    _current = _iterable.elementAt(_index);
    _index++;
    return true;
  }
}

typedef T _Transformation<S, T>(S value);

class MappedIterable<S, T> extends Iterable<T> {
  final Iterable<S> _iterable;
  final _Transformation<S, T> _f;

  factory MappedIterable(Iterable<S> iterable, T function(S value)) {
    if (iterable is EfficientLength) {
      return new EfficientLengthMappedIterable<S, T>(iterable, function);
    }
    return new MappedIterable<S, T>._(iterable, function);
  }

  MappedIterable._(this._iterable, T this._f(S element));

  Iterator<T> get iterator => new MappedIterator<S, T>(_iterable.iterator, _f);

  // Length related functions are independent of the mapping.
  int get length => _iterable.length;
  bool get isEmpty => _iterable.isEmpty;

  // Index based lookup can be done before transforming.
  T get first => _f(_iterable.first);
  T get last => _f(_iterable.last);
  T get single => _f(_iterable.single);
  T elementAt(int index) => _f(_iterable.elementAt(index));
}

class EfficientLengthMappedIterable<S, T> extends MappedIterable<S, T>
                                          implements EfficientLength {
  EfficientLengthMappedIterable(Iterable<S> iterable, T function(S value))
      : super._(iterable, function);
}

class MappedIterator<S, T> extends Iterator<T> {
  T _current;
  final Iterator<S> _iterator;
  final _Transformation<S, T> _f;

  MappedIterator(this._iterator, T this._f(S element));

  bool moveNext() {
    if (_iterator.moveNext()) {
      _current = _f(_iterator.current);
      return true;
    }
    _current = null;
    return false;
  }

  T get current => _current;
}

/**
 * Specialized alternative to [MappedIterable] for mapped [List]s.
 *
 * Expects efficient `length` and `elementAt` on the source iterable.
 */
class MappedListIterable<S, T> extends ListIterable<T>
                               implements EfficientLength {
  final Iterable<S> _source;
  final _Transformation<S, T> _f;

  MappedListIterable(this._source, T this._f(S value));

  int get length => _source.length;
  T elementAt(int index) => _f(_source.elementAt(index));
}


typedef bool _ElementPredicate<E>(E element);

class WhereIterable<E> extends Iterable<E> {
  final Iterable<E> _iterable;
  final _ElementPredicate<E> _f;

  WhereIterable(this._iterable, bool this._f(E element));

  Iterator<E> get iterator => new WhereIterator<E>(_iterable.iterator, _f);
}

class WhereIterator<E> extends Iterator<E> {
  final Iterator<E> _iterator;
  final _ElementPredicate<E> _f;

  WhereIterator(this._iterator, bool this._f(E element));

  bool moveNext() {
    while (_iterator.moveNext()) {
      if (_f(_iterator.current)) {
        return true;
      }
    }
    return false;
  }

  E get current => _iterator.current;
}

typedef Iterable<T> _ExpandFunction<S, T>(S sourceElement);

class ExpandIterable<S, T> extends Iterable<T> {
  final Iterable<S> _iterable;
  final _ExpandFunction<S, T> _f;

  ExpandIterable(this._iterable, Iterable<T> this._f(S element));

  Iterator<T> get iterator => new ExpandIterator<S, T>(_iterable.iterator, _f);
}

class ExpandIterator<S, T> implements Iterator<T> {
  final Iterator<S> _iterator;
  final _ExpandFunction<S, T> _f;
  // Initialize _currentExpansion to an empty iterable. A null value
  // marks the end of iteration, and we don't want to call _f before
  // the first moveNext call.
  Iterator<T> _currentExpansion = const EmptyIterator();
  T _current;

  ExpandIterator(this._iterator, Iterable<T> this._f(S element));

  T get current => _current;

  bool moveNext() {
    if (_currentExpansion == null) return false;
    while (!_currentExpansion.moveNext()) {
      _current = null;
      if (_iterator.moveNext()) {
        // If _f throws, this ends iteration. Otherwise _currentExpansion and
        // _current will be set again below.
        _currentExpansion = null;
        _currentExpansion = _f(_iterator.current).iterator;
      } else {
        return false;
      }
    }
    _current = _currentExpansion.current;
    return true;
  }
}

class TakeIterable<E> extends Iterable<E> {
  final Iterable<E> _iterable;
  final int _takeCount;

  factory TakeIterable(Iterable<E> iterable, int takeCount) {
    if (takeCount is! int || takeCount < 0) {
      throw new ArgumentError(takeCount);
    }
    if (iterable is EfficientLength) {
      return new EfficientLengthTakeIterable<E>(iterable, takeCount);
    }
    return new TakeIterable<E>._(iterable, takeCount);
  }

  TakeIterable._(this._iterable, this._takeCount);

  Iterator<E> get iterator {
    return new TakeIterator<E>(_iterable.iterator, _takeCount);
  }
}

class EfficientLengthTakeIterable<E> extends TakeIterable<E>
                                     implements EfficientLength {
  EfficientLengthTakeIterable(Iterable<E> iterable, int takeCount)
      : super._(iterable, takeCount);

  int get length {
    int iterableLength = _iterable.length;
    if (iterableLength > _takeCount) return _takeCount;
    return iterableLength;
  }
}


class TakeIterator<E> extends Iterator<E> {
  final Iterator<E> _iterator;
  int _remaining;

  TakeIterator(this._iterator, this._remaining) {
    assert(_remaining is int && _remaining >= 0);
  }

  bool moveNext() {
    _remaining--;
    if (_remaining >= 0) {
      return _iterator.moveNext();
    }
    _remaining = -1;
    return false;
  }

  E get current {
    if (_remaining < 0) return null;
    return _iterator.current;
  }
}

class TakeWhileIterable<E> extends Iterable<E> {
  final Iterable<E> _iterable;
  final _ElementPredicate<E> _f;

  TakeWhileIterable(this._iterable, bool this._f(E element));

  Iterator<E> get iterator {
    return new TakeWhileIterator<E>(_iterable.iterator, _f);
  }
}

class TakeWhileIterator<E> extends Iterator<E> {
  final Iterator<E> _iterator;
  final _ElementPredicate<E> _f;
  bool _isFinished = false;

  TakeWhileIterator(this._iterator, bool this._f(E element));

  bool moveNext() {
    if (_isFinished) return false;
    if (!_iterator.moveNext() || !_f(_iterator.current)) {
      _isFinished = true;
      return false;
    }
    return true;
  }

  E get current {
    if (_isFinished) return null;
    return _iterator.current;
  }
}

class SkipIterable<E> extends Iterable<E> {
  final Iterable<E> _iterable;
  final int _skipCount;

  factory SkipIterable(Iterable<E> iterable, int count) {
    if (iterable is EfficientLength) {
      return new EfficientLengthSkipIterable<E>(iterable, count);
    }
    return new SkipIterable<E>._(iterable, count);
  }

  SkipIterable._(this._iterable, this._skipCount) {
    if (_skipCount is! int) {
      throw new ArgumentError.value(_skipCount, "count is not an integer");
    }
    RangeError.checkNotNegative(_skipCount, "count");
  }

  Iterable<E> skip(int count) {
    if (_skipCount is! int) {
      throw new ArgumentError.value(_skipCount, "count is not an integer");
    }
    RangeError.checkNotNegative(_skipCount, "count");
    return new SkipIterable<E>._(_iterable, _skipCount + count);
  }

  Iterator<E> get iterator {
    return new SkipIterator<E>(_iterable.iterator, _skipCount);
  }
}

class EfficientLengthSkipIterable<E> extends SkipIterable<E>
                                     implements EfficientLength {
  EfficientLengthSkipIterable(Iterable<E> iterable, int skipCount)
      : super._(iterable, skipCount);

  int get length {
    int length = _iterable.length - _skipCount;
    if (length >= 0) return length;
    return 0;
  }
}

class SkipIterator<E> extends Iterator<E> {
  final Iterator<E> _iterator;
  int _skipCount;

  SkipIterator(this._iterator, this._skipCount) {
    assert(_skipCount is int && _skipCount >= 0);
  }

  bool moveNext() {
    for (int i = 0; i < _skipCount; i++) _iterator.moveNext();
    _skipCount = 0;
    return _iterator.moveNext();
  }

  E get current => _iterator.current;
}

class SkipWhileIterable<E> extends Iterable<E> {
  final Iterable<E> _iterable;
  final _ElementPredicate<E> _f;

  SkipWhileIterable(this._iterable, bool this._f(E element));

  Iterator<E> get iterator {
    return new SkipWhileIterator<E>(_iterable.iterator, _f);
  }
}

class SkipWhileIterator<E> extends Iterator<E> {
  final Iterator<E> _iterator;
  final _ElementPredicate<E> _f;
  bool _hasSkipped = false;

  SkipWhileIterator(this._iterator, bool this._f(E element));

  bool moveNext() {
    if (!_hasSkipped) {
      _hasSkipped = true;
      while (_iterator.moveNext()) {
        if (!_f(_iterator.current)) return true;
      }
    }
    return _iterator.moveNext();
  }

  E get current => _iterator.current;
}

/**
 * The always empty [Iterable].
 */
class EmptyIterable<E> extends Iterable<E> implements EfficientLength {
  const EmptyIterable();

  Iterator<E> get iterator => const EmptyIterator();

  void forEach(void action(E element)) {}

  bool get isEmpty => true;

  int get length => 0;

  E get first { throw IterableElementError.noElement(); }

  E get last { throw IterableElementError.noElement(); }

  E get single { throw IterableElementError.noElement(); }

  E elementAt(int index) { throw new RangeError.range(index, 0, 0, "index"); }

  bool contains(Object element) => false;

  bool every(bool test(E element)) => true;

  bool any(bool test(E element)) => false;

  E firstWhere(bool test(E element), {E orElse()}) {
    if (orElse != null) return orElse();
    throw IterableElementError.noElement();
  }

  E lastWhere(bool test(E element), {E orElse()}) {
    if (orElse != null) return orElse();
    throw IterableElementError.noElement();
  }

  E singleWhere(bool test(E element), {E orElse()}) {
    if (orElse != null) return orElse();
    throw IterableElementError.noElement();
  }

  String join([String separator = ""]) => "";

  Iterable<E> where(bool test(E element)) => this;

  Iterable/*<T>*/ map/*<T>*/(/*=T*/ f(E element)) => const EmptyIterable();

  E reduce(E combine(E value, E element)) {
    throw IterableElementError.noElement();
  }

  /*=T*/ fold/*<T>*/(
      var/*=T*/ initialValue, /*=T*/ combine(
          var/*=T*/ previousValue, E element)) {
    return initialValue;
  }

  Iterable<E> skip(int count) {
    RangeError.checkNotNegative(count, "count");
    return this;
  }

  Iterable<E> skipWhile(bool test(E element)) => this;

  Iterable<E> take(int count) {
    RangeError.checkNotNegative(count, "count");
    return this;
  }

  Iterable<E> takeWhile(bool test(E element)) => this;

  List<E> toList({bool growable: true}) => growable ? <E>[] : new List<E>(0);

  Set<E> toSet() => new Set<E>();
}

/** The always empty iterator. */
class EmptyIterator<E> implements Iterator<E> {
  const EmptyIterator();
  bool moveNext() => false;
  E get current => null;
}

/**
 * This class provides default implementations for Iterables (including Lists).
 *
 * The uses of this class will be replaced by mixins.
 */
class IterableMixinWorkaround<T> {
  static bool contains/*<E>*/(Iterable/*<E>*/ iterable, var element) {
    for (final e in iterable) {
      if (e == element) return true;
    }
    return false;
  }

  static void forEach/*<E>*/(Iterable/*<E>*/ iterable, void f(/*=E*/ o)) {
    for (final e in iterable) {
      f(e);
    }
  }

  static bool any/*<E>*/(Iterable/*<E>*/ iterable, bool f(/*=E*/ o)) {
    for (final e in iterable) {
      if (f(e)) return true;
    }
    return false;
  }

  static bool every/*<E>*/(Iterable/*<E>*/ iterable, bool f(/*=E*/ o)) {
    for (final e in iterable) {
      if (!f(e)) return false;
    }
    return true;
  }

  static dynamic/*=E*/ reduce/*<E>*/(Iterable/*<E>*/ iterable,
      dynamic/*=E*/ combine(/*=E*/ previousValue, /*=E*/ element)) {
    Iterator/*<E>*/ iterator = iterable.iterator;
    if (!iterator.moveNext()) throw IterableElementError.noElement();
    var value = iterator.current;
    while (iterator.moveNext()) {
      value = combine(value, iterator.current);
    }
    return value;
  }

  static/*=V*/ fold/*<E, V>*/(
      Iterable/*<E>*/ iterable,
      dynamic/*=V*/ initialValue,
      dynamic/*=V*/ combine(dynamic/*=V*/ previousValue, /*=E*/ element)) {
    for (final element in iterable) {
      initialValue = combine(initialValue, element);
    }
    return initialValue;
  }

  /**
   * Removes elements matching [test] from [list].
   *
   * This is performed in two steps, to avoid exposing an inconsistent state
   * to the [test] function. First the elements to retain are found, and then
   * the original list is updated to contain those elements.
   */
  static void removeWhereList/*<E>*/(
      List/*<E>*/ list, bool test(var/*=E*/ element)) {
    List/*<E>*/ retained = [];
    int length = list.length;
    for (int i = 0; i < length; i++) {
      var element = list[i];
      if (!test(element)) {
        retained.add(element);
      }
      if (length != list.length) {
        throw new ConcurrentModificationError(list);
      }
    }
    if (retained.length == length) return;
    list.length = retained.length;
    for (int i = 0; i < retained.length; i++) {
      list[i] = retained[i];
    }
  }

  static bool isEmpty/*<E>*/(Iterable/*<E>*/ iterable) {
    return !iterable.iterator.moveNext();
  }

  static dynamic/*=E*/ first/*<E>*/(Iterable/*<E>*/ iterable) {
    Iterator/*<E>*/ it = iterable.iterator;
    if (!it.moveNext()) {
      throw IterableElementError.noElement();
    }
    return it.current;
  }

  static dynamic/*=E*/ last/*<E>*/(Iterable/*<E>*/ iterable) {
    Iterator/*<E>*/ it = iterable.iterator;
    if (!it.moveNext()) {
      throw IterableElementError.noElement();
    }
    var/*=E*/ result;
    do {
      result = it.current;
    } while (it.moveNext());
    return result;
  }

  static dynamic/*=E*/ single/*<E>*/(Iterable/*<E>*/ iterable) {
    Iterator/*<E>*/ it = iterable.iterator;
    if (!it.moveNext()) throw IterableElementError.noElement();
    var result = it.current;
    if (it.moveNext()) throw IterableElementError.tooMany();
    return result;
  }

  static dynamic/*=E*/ firstWhere/*<E>*/(Iterable/*<E>*/ iterable,
      bool test(dynamic/*=E*/ value), dynamic/*=E*/ orElse()) {
    for (var element in iterable) {
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();
    throw IterableElementError.noElement();
  }

  static dynamic/*=E*/ lastWhere/*<E>*/(Iterable/*<E>*/ iterable,
      bool test(dynamic/*=E*/ value), dynamic/*=E*/ orElse()) {
    dynamic/*=E*/ result = null;
    bool foundMatching = false;
    for (var element in iterable) {
      if (test(element)) {
        result = element;
        foundMatching = true;
      }
    }
    if (foundMatching) return result;
    if (orElse != null) return orElse();
    throw IterableElementError.noElement();
  }

  static dynamic/*=E*/ lastWhereList/*<E>*/(List/*<E>*/ list,
      bool test(dynamic/*=E*/ value), dynamic/*=E*/ orElse()) {
    // TODO(floitsch): check that arguments are of correct type?
    for (int i = list.length - 1; i >= 0; i--) {
      var element = list[i];
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();
    throw IterableElementError.noElement();
  }

  static dynamic/*=E*/ singleWhere/*<E>*/(
      Iterable/*<E>*/ iterable, bool test(dynamic/*=E*/ value)) {
    dynamic/*=E*/ result = null;
    bool foundMatching = false;
    for (var element in iterable) {
      if (test(element)) {
        if (foundMatching) {
          throw IterableElementError.tooMany();
        }
        result = element;
        foundMatching = true;
      }
    }
    if (foundMatching) return result;
    throw IterableElementError.noElement();
  }

  static dynamic/*=E*/ elementAt/*<E>*/(Iterable/*<E>*/ iterable, int index) {
    if (index is! int) throw new ArgumentError.notNull("index");
    RangeError.checkNotNegative(index, "index");
    int elementIndex = 0;
    for (var element in iterable) {
      if (index == elementIndex) return element;
      elementIndex++;
    }
    throw new RangeError.index(index, iterable, "index", null, elementIndex);
  }

  static String join/*<E>*/(Iterable/*<E>*/ iterable, [String separator]) {
    StringBuffer buffer = new StringBuffer();
    buffer.writeAll(iterable, separator);
    return buffer.toString();
  }

  static String joinList/*<E>*/(List/*<E>*/ list, [String separator]) {
    if (list.isEmpty) return "";
    if (list.length == 1) return "${list[0]}";
    StringBuffer buffer = new StringBuffer();
    if (separator.isEmpty) {
      for (int i = 0; i < list.length; i++) {
        buffer.write(list[i]);
      }
    } else {
      buffer.write(list[0]);
      for (int i = 1; i < list.length; i++) {
        buffer.write(separator);
        buffer.write(list[i]);
      }
    }
    return buffer.toString();
  }

  Iterable<T> where(Iterable<T> iterable, bool f(T element)) {
    return new WhereIterable<T>(iterable, f);
  }

  static Iterable/*<V>*/ map/*<E, V>*/(
      Iterable/*<E>*/ iterable, /*=V*/ f(var/*=E*/ element)) {
    return new MappedIterable/*<E, V>*/(iterable, f);
  }

  static Iterable/*<V>*/ mapList/*<E, V>*/(
      List/*<E>*/ list, /*=V*/ f(var/*=E*/ element)) {
    return new MappedListIterable/*<E, V>*/(list, f);
  }

  static Iterable/*<V>*/ expand/*<E, V>*/(
      Iterable/*<E>*/ iterable, Iterable/*<V>*/ f(var/*=E*/ element)) {
    return new ExpandIterable/*<E, V>*/(iterable, f);
  }

  Iterable<T> takeList(List list, int n) {
    // The generic type is currently lost. It will be fixed with mixins.
    return new SubListIterable<T>(list, 0, n);
  }

  Iterable<T> takeWhile(Iterable iterable, bool test(var value)) {
    // The generic type is currently lost. It will be fixed with mixins.
    return new TakeWhileIterable<T>(iterable, test);
  }

  Iterable<T> skipList(List list, int n) {
    // The generic type is currently lost. It will be fixed with mixins.
    return new SubListIterable<T>(list, n, null);
  }

  Iterable<T> skipWhile(Iterable iterable, bool test(var value)) {
    // The generic type is currently lost. It will be fixed with mixins.
    return new SkipWhileIterable<T>(iterable, test);
  }

  Iterable<T> reversedList(List list) {
    return new ReversedListIterable<T>(list);
  }

  static void sortList(List list, int compare(a, b)) {
    if (compare == null) compare = Comparable.compare;
    Sort.sort(list, compare);
  }

  static void shuffleList(List list, Random random) {
    if (random == null) random = new Random();
    int length = list.length;
    while (length > 1) {
      int pos = random.nextInt(length);
      length -= 1;
      var tmp = list[length];
      list[length] = list[pos];
      list[pos] = tmp;
    }
  }

  static int indexOfList(List list, var element, int start) {
    return Lists.indexOf(list, element, start, list.length);
  }

  static int lastIndexOfList(List list, var element, int start) {
    if (start == null) start = list.length - 1;
    return Lists.lastIndexOf(list, element, start);
  }

  static void _rangeCheck(List list, int start, int end) {
    RangeError.checkValidRange(start, end, list.length);
  }

  Iterable<T> getRangeList(List list, int start, int end) {
    _rangeCheck(list, start, end);
    // The generic type is currently lost. It will be fixed with mixins.
    return new SubListIterable<T>(list, start, end);
  }

  static void setRangeList(
      List list, int start, int end, Iterable from, int skipCount) {
    _rangeCheck(list, start, end);
    int length = end - start;
    if (length == 0) return;

    if (skipCount < 0) throw new ArgumentError(skipCount);

    // TODO(floitsch): Make this accept more.
    List otherList;
    int otherStart;
    if (from is List) {
      otherList = from;
      otherStart = skipCount;
    } else {
      otherList = from.skip(skipCount).toList(growable: false);
      otherStart = 0;
    }
    if (otherStart + length > otherList.length) {
      throw IterableElementError.tooFew();
    }
    Lists.copy(otherList, otherStart, list, start, length);
  }

  static void replaceRangeList(
      List list, int start, int end, Iterable iterable) {
    _rangeCheck(list, start, end);
    if (iterable is! EfficientLength) {
      iterable = iterable.toList();
    }
    int removeLength = end - start;
    int insertLength = iterable.length;
    if (removeLength >= insertLength) {
      int delta = removeLength - insertLength;
      int insertEnd = start + insertLength;
      int newEnd = list.length - delta;
      list.setRange(start, insertEnd, iterable);
      if (delta != 0) {
        list.setRange(insertEnd, newEnd, list, end);
        list.length = newEnd;
      }
    } else {
      int delta = insertLength - removeLength;
      int newLength = list.length + delta;
      int insertEnd = start + insertLength; // aka. end + delta.
      list.length = newLength;
      list.setRange(insertEnd, newLength, list, end);
      list.setRange(start, insertEnd, iterable);
    }
  }

  static void fillRangeList(List list, int start, int end, fillValue) {
    _rangeCheck(list, start, end);
    for (int i = start; i < end; i++) {
      list[i] = fillValue;
    }
  }

  static void insertAllList(List list, int index, Iterable iterable) {
    RangeError.checkValueInInterval(index, 0, list.length, "index");
    if (iterable is! EfficientLength) {
      iterable = iterable.toList(growable: false);
    }
    int insertionLength = iterable.length;
    list.length += insertionLength;
    list.setRange(index + insertionLength, list.length, list, index);
    for (var element in iterable) {
      list[index++] = element;
    }
  }

  static void setAllList(List list, int index, Iterable iterable) {
    RangeError.checkValueInInterval(index, 0, list.length, "index");
    for (var element in iterable) {
      list[index++] = element;
    }
  }

  Map<int, T> asMapList(List l) {
    return new ListMapView<T>(l);
  }

  static bool setContainsAll(Set set, Iterable other) {
    for (var element in other) {
      if (!set.contains(element)) return false;
    }
    return true;
  }

  static Set setIntersection(Set set, Set other, Set result) {
    Set smaller;
    Set larger;
    if (set.length < other.length) {
      smaller = set;
      larger = other;
    } else {
      smaller = other;
      larger = set;
    }
    for (var element in smaller) {
      if (larger.contains(element)) {
        result.add(element);
      }
    }
    return result;
  }

  static Set setUnion(Set set, Set other, Set result) {
    result.addAll(set);
    result.addAll(other);
    return result;
  }

  static Set setDifference(Set set, Set other, Set result) {
    for (var element in set) {
      if (!other.contains(element)) {
        result.add(element);
      }
    }
    return result;
  }
}

/**
 * Creates errors throw by [Iterable] when the element count is wrong.
 */
abstract class IterableElementError {
  /** Error thrown thrown by, e.g., [Iterable.first] when there is no result. */
  static StateError noElement() => new StateError("No element");
  /** Error thrown by, e.g., [Iterable.single] if there are too many results. */
  static StateError tooMany() => new StateError("Too many elements");
  /** Error thrown by, e.g., [List.setRange] if there are too few elements. */
  static StateError tooFew() => new StateError("Too few elements");
}
