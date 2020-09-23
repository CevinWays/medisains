


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medisains/helpers/sharedpref_helper.dart';
import 'package:medisains/pages/splash/bloc/splash_export.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState>{
  SplashBloc(SplashState initialState) : super(initialState);

  @override
  // TODO: implement initialState
  SplashState get initialState => SplashInitState();

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async*{
    // TODO: implement mapEventToState
    if(event is LoadNextPageEvent){
      yield* _mapLoadNextPageEvent();
    }
  }

  Stream<SplashState> _mapLoadNextPageEvent() async*{
    yield SplashInitState();
    bool _isLogin = SharedPrefHelper.isUserLogin();

    if(_isLogin){
      yield GoToHomePageState();
    }else{
      yield GotoOnBoardingState();
    }
  }
}