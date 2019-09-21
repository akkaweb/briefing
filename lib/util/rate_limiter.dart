///Utility class that decides whether we should fetch some data or not.
import 'package:briefing/repository/repository.dart';

class RateLimiter {
  Map<String, int> timestamps = new Map();

  final int _timeout;

  ///[_timeout] : rate at which we should fetch data in minutes
//  RateLimiter(this._timeout);

  static final RateLimiter _rateLimiter = RateLimiter._internal();

  factory RateLimiter() {
    return _rateLimiter;
  }

  RateLimiter._internal([this._timeout = 2]);
}

RateLimiter getRateLimiter = RateLimiter();
