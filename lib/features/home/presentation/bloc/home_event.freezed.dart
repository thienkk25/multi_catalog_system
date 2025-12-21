// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEvent {

 int get index; String get title;
/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeEventCopyWith<HomeEvent> get copyWith => _$HomeEventCopyWithImpl<HomeEvent>(this as HomeEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEvent&&(identical(other.index, index) || other.index == index)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,index,title);

@override
String toString() {
  return 'HomeEvent(index: $index, title: $title)';
}


}

/// @nodoc
abstract mixin class $HomeEventCopyWith<$Res>  {
  factory $HomeEventCopyWith(HomeEvent value, $Res Function(HomeEvent) _then) = _$HomeEventCopyWithImpl;
@useResult
$Res call({
 int index, String title
});




}
/// @nodoc
class _$HomeEventCopyWithImpl<$Res>
    implements $HomeEventCopyWith<$Res> {
  _$HomeEventCopyWithImpl(this._self, this._then);

  final HomeEvent _self;
  final $Res Function(HomeEvent) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? title = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _ChangePage value)?  changePage,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChangePage() when changePage != null:
return changePage(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _ChangePage value)  changePage,}){
final _that = this;
switch (_that) {
case _ChangePage():
return changePage(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _ChangePage value)?  changePage,}){
final _that = this;
switch (_that) {
case _ChangePage() when changePage != null:
return changePage(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int index,  String title)?  changePage,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChangePage() when changePage != null:
return changePage(_that.index,_that.title);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int index,  String title)  changePage,}) {final _that = this;
switch (_that) {
case _ChangePage():
return changePage(_that.index,_that.title);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int index,  String title)?  changePage,}) {final _that = this;
switch (_that) {
case _ChangePage() when changePage != null:
return changePage(_that.index,_that.title);case _:
  return null;

}
}

}

/// @nodoc


class _ChangePage implements HomeEvent {
  const _ChangePage(this.index, this.title);
  

@override final  int index;
@override final  String title;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChangePageCopyWith<_ChangePage> get copyWith => __$ChangePageCopyWithImpl<_ChangePage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChangePage&&(identical(other.index, index) || other.index == index)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,index,title);

@override
String toString() {
  return 'HomeEvent.changePage(index: $index, title: $title)';
}


}

/// @nodoc
abstract mixin class _$ChangePageCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory _$ChangePageCopyWith(_ChangePage value, $Res Function(_ChangePage) _then) = __$ChangePageCopyWithImpl;
@override @useResult
$Res call({
 int index, String title
});




}
/// @nodoc
class __$ChangePageCopyWithImpl<$Res>
    implements _$ChangePageCopyWith<$Res> {
  __$ChangePageCopyWithImpl(this._self, this._then);

  final _ChangePage _self;
  final $Res Function(_ChangePage) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? title = null,}) {
  return _then(_ChangePage(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
