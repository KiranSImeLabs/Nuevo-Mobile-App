// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'questionnaire_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuestionnaireState {

 int get currentIndex; Map<String, Set<String>> get selectedOptionIds; Map<String, String> get textAnswers; bool get isSubmitting; String? get submitError; bool get submitSuccess;
/// Create a copy of QuestionnaireState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionnaireStateCopyWith<QuestionnaireState> get copyWith => _$QuestionnaireStateCopyWithImpl<QuestionnaireState>(this as QuestionnaireState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionnaireState&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other.selectedOptionIds, selectedOptionIds)&&const DeepCollectionEquality().equals(other.textAnswers, textAnswers)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitError, submitError) || other.submitError == submitError)&&(identical(other.submitSuccess, submitSuccess) || other.submitSuccess == submitSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,currentIndex,const DeepCollectionEquality().hash(selectedOptionIds),const DeepCollectionEquality().hash(textAnswers),isSubmitting,submitError,submitSuccess);

@override
String toString() {
  return 'QuestionnaireState(currentIndex: $currentIndex, selectedOptionIds: $selectedOptionIds, textAnswers: $textAnswers, isSubmitting: $isSubmitting, submitError: $submitError, submitSuccess: $submitSuccess)';
}


}

/// @nodoc
abstract mixin class $QuestionnaireStateCopyWith<$Res>  {
  factory $QuestionnaireStateCopyWith(QuestionnaireState value, $Res Function(QuestionnaireState) _then) = _$QuestionnaireStateCopyWithImpl;
@useResult
$Res call({
 int currentIndex, Map<String, Set<String>> selectedOptionIds, Map<String, String> textAnswers, bool isSubmitting, String? submitError, bool submitSuccess
});




}
/// @nodoc
class _$QuestionnaireStateCopyWithImpl<$Res>
    implements $QuestionnaireStateCopyWith<$Res> {
  _$QuestionnaireStateCopyWithImpl(this._self, this._then);

  final QuestionnaireState _self;
  final $Res Function(QuestionnaireState) _then;

/// Create a copy of QuestionnaireState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentIndex = null,Object? selectedOptionIds = null,Object? textAnswers = null,Object? isSubmitting = null,Object? submitError = freezed,Object? submitSuccess = null,}) {
  return _then(_self.copyWith(
currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,selectedOptionIds: null == selectedOptionIds ? _self.selectedOptionIds : selectedOptionIds // ignore: cast_nullable_to_non_nullable
as Map<String, Set<String>>,textAnswers: null == textAnswers ? _self.textAnswers : textAnswers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as String?,submitSuccess: null == submitSuccess ? _self.submitSuccess : submitSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionnaireState].
extension QuestionnaireStatePatterns on QuestionnaireState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionnaireState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionnaireState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionnaireState value)  $default,){
final _that = this;
switch (_that) {
case _QuestionnaireState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionnaireState value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionnaireState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentIndex,  Map<String, Set<String>> selectedOptionIds,  Map<String, String> textAnswers,  bool isSubmitting,  String? submitError,  bool submitSuccess)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionnaireState() when $default != null:
return $default(_that.currentIndex,_that.selectedOptionIds,_that.textAnswers,_that.isSubmitting,_that.submitError,_that.submitSuccess);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentIndex,  Map<String, Set<String>> selectedOptionIds,  Map<String, String> textAnswers,  bool isSubmitting,  String? submitError,  bool submitSuccess)  $default,) {final _that = this;
switch (_that) {
case _QuestionnaireState():
return $default(_that.currentIndex,_that.selectedOptionIds,_that.textAnswers,_that.isSubmitting,_that.submitError,_that.submitSuccess);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentIndex,  Map<String, Set<String>> selectedOptionIds,  Map<String, String> textAnswers,  bool isSubmitting,  String? submitError,  bool submitSuccess)?  $default,) {final _that = this;
switch (_that) {
case _QuestionnaireState() when $default != null:
return $default(_that.currentIndex,_that.selectedOptionIds,_that.textAnswers,_that.isSubmitting,_that.submitError,_that.submitSuccess);case _:
  return null;

}
}

}

/// @nodoc


class _QuestionnaireState implements QuestionnaireState {
  const _QuestionnaireState({this.currentIndex = 0, final  Map<String, Set<String>> selectedOptionIds = const {}, final  Map<String, String> textAnswers = const {}, this.isSubmitting = false, this.submitError, this.submitSuccess = false}): _selectedOptionIds = selectedOptionIds,_textAnswers = textAnswers;
  

@override@JsonKey() final  int currentIndex;
 final  Map<String, Set<String>> _selectedOptionIds;
@override@JsonKey() Map<String, Set<String>> get selectedOptionIds {
  if (_selectedOptionIds is EqualUnmodifiableMapView) return _selectedOptionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_selectedOptionIds);
}

 final  Map<String, String> _textAnswers;
@override@JsonKey() Map<String, String> get textAnswers {
  if (_textAnswers is EqualUnmodifiableMapView) return _textAnswers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_textAnswers);
}

@override@JsonKey() final  bool isSubmitting;
@override final  String? submitError;
@override@JsonKey() final  bool submitSuccess;

/// Create a copy of QuestionnaireState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionnaireStateCopyWith<_QuestionnaireState> get copyWith => __$QuestionnaireStateCopyWithImpl<_QuestionnaireState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionnaireState&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other._selectedOptionIds, _selectedOptionIds)&&const DeepCollectionEquality().equals(other._textAnswers, _textAnswers)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitError, submitError) || other.submitError == submitError)&&(identical(other.submitSuccess, submitSuccess) || other.submitSuccess == submitSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,currentIndex,const DeepCollectionEquality().hash(_selectedOptionIds),const DeepCollectionEquality().hash(_textAnswers),isSubmitting,submitError,submitSuccess);

@override
String toString() {
  return 'QuestionnaireState(currentIndex: $currentIndex, selectedOptionIds: $selectedOptionIds, textAnswers: $textAnswers, isSubmitting: $isSubmitting, submitError: $submitError, submitSuccess: $submitSuccess)';
}


}

/// @nodoc
abstract mixin class _$QuestionnaireStateCopyWith<$Res> implements $QuestionnaireStateCopyWith<$Res> {
  factory _$QuestionnaireStateCopyWith(_QuestionnaireState value, $Res Function(_QuestionnaireState) _then) = __$QuestionnaireStateCopyWithImpl;
@override @useResult
$Res call({
 int currentIndex, Map<String, Set<String>> selectedOptionIds, Map<String, String> textAnswers, bool isSubmitting, String? submitError, bool submitSuccess
});




}
/// @nodoc
class __$QuestionnaireStateCopyWithImpl<$Res>
    implements _$QuestionnaireStateCopyWith<$Res> {
  __$QuestionnaireStateCopyWithImpl(this._self, this._then);

  final _QuestionnaireState _self;
  final $Res Function(_QuestionnaireState) _then;

/// Create a copy of QuestionnaireState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentIndex = null,Object? selectedOptionIds = null,Object? textAnswers = null,Object? isSubmitting = null,Object? submitError = freezed,Object? submitSuccess = null,}) {
  return _then(_QuestionnaireState(
currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,selectedOptionIds: null == selectedOptionIds ? _self._selectedOptionIds : selectedOptionIds // ignore: cast_nullable_to_non_nullable
as Map<String, Set<String>>,textAnswers: null == textAnswers ? _self._textAnswers : textAnswers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitError: freezed == submitError ? _self.submitError : submitError // ignore: cast_nullable_to_non_nullable
as String?,submitSuccess: null == submitSuccess ? _self.submitSuccess : submitSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
