import 'package:school_enhancer_app/common/ui/ui_helper.dart';
import 'package:school_enhancer_app/common/ui/widgets/filled_button.dart';
import 'package:school_enhancer_app/features/login/view_model/login_view_model.dart';
import 'package:stacked/stacked.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        disposeViewModel: true,
        builder: (context, model, child) {
          return Scaffold(
            body: Stack(
              children: [
                ListView(
                  padding: lPadding,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 72,
                          fit: BoxFit.fitHeight,
                        ),
                        lHeightSpan,
                        _textFieldSection(context, model),
                        lHeightSpan,
                        Text(
                          'Forgot your password?',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .color!
                                      .withOpacity(0.5)),
                        ),
                        mHeightSpan,
                        SizedBox(
                          width: widthFactor(context),
                          height: 44,
                          child: KButton(
                            child: const Text("Continue"),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              model.login();
                            },
                          ),
                        ),
                        mHeightSpan,
                      ],
                    ),
                  ],
                ),
                if (model.isLoading) const KLoader(),
              ],
            ),
          );
        });
  }

  Widget _textFieldSection(BuildContext context, LoginViewModel model) =>
      Center(
        child: Column(
          children: [
            KTextFormField(
              onChanged: model.onPhoneChanged,
              prefixIcon: const Icon(Icons.email),
              labelText: "Email",
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            mHeightSpan,
            KPasswordTextFormField(
              onChanged: model.onPasswordChanged,
              labelText: "Password",
            ),
          ],
        ),
      );
}