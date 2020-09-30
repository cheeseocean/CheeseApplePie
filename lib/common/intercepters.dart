import 'package:cheese_flutter/common/global.dart';
import 'package:cheese_flutter/utils/log_utils.dart';
import 'package:dio/dio.dart';

import 'error_handle.dart';

class LoggingInterceptor extends Interceptor{

  DateTime _startTime;
  DateTime _endTime;
  
  @override
  Future onRequest(RequestOptions options) {
    _startTime = DateTime.now();
    // print("--------start------------${Global.isRelease}");
    Log.d('----------Start----------');
    if (options.queryParameters.isEmpty) {
      Log.d('RequestUrl: ' + options.baseUrl + options.path);
    } else {
      Log.d('RequestUrl: ' + options.baseUrl + options.path + '?' + Transformer.urlEncodeMap(options.queryParameters));
    }
    Log.d('RequestMethod: ' + options.method);
    Log.d('RequestHeaders:' + options.headers.toString());
    Log.d('RequestContentType: ${options.contentType}');
    Log.d('RequestData: ${options.data.toString()}');
    return super.onRequest(options);
  }
  
  @override
  Future onResponse(Response response) {
    _endTime = DateTime.now();
    int duration = _endTime.difference(_startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      Log.d('ResponseCode: ${response.statusCode}');
    } else {
      Log.e('ResponseCode: ${response.statusCode}');
    }
    // 输出结果
    Log.json(response.data.toString());
    Log.d('----------End: $duration 毫秒----------');
    return super.onResponse(response);
  }
  
  @override
  Future onError(DioError err) {
    Log.d('----------Error-----------');
    Log.d('Error Response: ${err.response.data} ------');
    return super.onError(err);
  }
}