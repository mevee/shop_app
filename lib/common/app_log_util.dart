import 'package:flutter/foundation.dart';

void aLog(message){
  if(kDebugMode) {
    print(message);
  }
}