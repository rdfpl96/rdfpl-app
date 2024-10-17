class AppExceptions implements Exception{
  final _message;
  final _prefix;
  AppExceptions([this._message,this._prefix]);

  String toString(){
    return '$_prefix $_message';
  }
}

class FetDataException extends AppExceptions{
  // FetDataException([String? message]):super(message,'Error During Communication');
  FetDataException([String? message]):super(message,'Error:');
}

class BadRequestException extends AppExceptions{
  BadRequestException([String? message]):super(message,'Invalid Request');
}

class UnAuthorizedException extends AppExceptions{
  UnAuthorizedException([String? message]):super(message,'Unauthorized Request');
}

class InvalidException extends AppExceptions{
  InvalidException([String? message]):super(message,'Invalid Input Request');
}

class UnCaughtAtServerException extends AppExceptions{
  UnCaughtAtServerException([String? message]):super(message,'Server Down');
}