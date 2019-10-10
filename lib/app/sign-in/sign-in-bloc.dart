import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_time_tracker/app/common/services/auth.dart';
 
class SignInBloc  {
   SignInBloc({@required this.auth});
   final AuthBase auth; 

   StreamController<bool>  _isLoadingController = StreamController<bool>(); 


   Stream<bool> get isLoadingStream =>  _isLoadingController.stream;

   void dispose() {
        _isLoadingController.close();
   }

   void _setIsLoading(isLoading) {
       _isLoadingController.add(isLoading);
   }


  Future<User> _signIn(Future<User> Function()  signInMethod)  async  {
      try {
            _setIsLoading(true);
            return await signInMethod();
      } catch (exception) {
             rethrow;
      } finally {
            _setIsLoading(false);
      }
  }
 
   Future<User> signInAnonymously() async  =>  await _signIn(auth.signInAnonymously);
    
   Future<User> signInWithGoogle() async  =>  await _signIn(auth.signInWithGoogle);
  
   Future<User> signInWithFacebook() async  =>  await _signIn(auth.signInWithFacebook);

}