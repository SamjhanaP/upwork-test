import 'package:school_enhancer_app/common/service/toast_service.dart';
import 'package:school_enhancer_app/core/dependency_injection/injection.dart';
import 'package:school_enhancer_app/core/model/base_view_model.dart';
import 'package:school_enhancer_app/data/api_service/auth/models/login_request_model.dart';
import 'package:school_enhancer_app/data/repository/auth_repository.dart';
import 'package:stacked/stacked.dart';

import '../../../data/api_service/auth/models/user_model.dart';

class LoginViewModel extends BaseViewModel with KBaseViewModel {
  final ToastService _toastService = injection<ToastService>();
  final IAuthRepository _authRepository = injection<IAuthRepository>();

  login() async {
    if (_phoneNumber.isEmpty) {
      _toastService.e('Invalid phone number');
      return;
    }

    if (_password.isEmpty || _password.length < 6) {
      _toastService.e('Password must be at least 6 characters');
      return;
    }

    setLoading(true);

    final response = await _authRepository.login(LoginRequestModel(
      phoneNumber: _phoneNumber,
      password: _password,
    ));

    response.fold(
      (l) => _toastService.e(l.failure),
      (r) {
        if (r.payload?.userRoles?.contains(UserRole.parent) ?? false) {
          if (r.payload?.parentId == null) {
            _toastService.e(
              "Contact school administration for parent login credentials",
            );
            return;
          }
          userDataService.saveUser(r);
          navigationService.clearStackAndShow(Routes.splashPage);
        } else {
          _toastService.e(
            "Contact school administration for parent login credentials",
          );
        }
      },
    );

    setLoading(false);
  }

  String _phoneNumber = "";
  String _password = "";

  void onPhoneChanged(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void onPasswordChanged(String password) {
    _password = password;
    notifyListeners();
  }
}