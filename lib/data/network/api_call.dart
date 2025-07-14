import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'handle_exception.dart';
import 'network_exception.dart';

Future<void> apiCall<T>(Future<T> call,
    {ValueChanged<String>? fail, ValueChanged<T>? success}) async {
  try {
    final response = await call;
    if (success != null) {
      success(response);
    }
  } catch (error) {
    if (fail != null) {
      try {
        final dioError = error as DioException;
        handleNetworkException(dioError);
      } on TokenException catch (e) {
        fail(e.message);
      } on UserException catch (e) {
        fail(e.message);
      } on AuthException catch (e) {
        fail(e.message);
      } on UnknownException catch (e) {
        fail(e.message);
      } on ApiException catch (e) {
        fail(e.message);
      } on InternetException catch (e) {
        fail(e.message);
      } catch (e) {
        fail(e.toString());
      }
    }
  }
}
