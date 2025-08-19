import 'package:flutter/foundation.dart';

void aLog(message){
  if(kDebugMode|kProfileMode) {
    print(message);
  }
}