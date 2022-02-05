part of 'pages.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emails = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool isLoading = false;
  bool isChecked = false;
  bool passwordVisible = true;
  final _formKey = GlobalKey<FormState>();

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // margin: EdgeInsets.fromLTRB(10, 59, 10, 10),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/cloudbig.png'),
                        fit: BoxFit.fill)),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Enter your registered email on Machat')),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) => EmailValidator.validate(value!)
                              ? null
                              : "Please enter a valid email",
                          onSaved: (value) => emails.text = value!,
                          controller: emails,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "Enter your email",
                            labelText: "Email",
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff036bca)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: Color(0xff036bca), width: 2.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            resetPassword(emails.text);
                          },
                          label: Text('SUBMIT'),
                          icon: isLoading
                              ? SizedBox(
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                  height: 20.0,
                                  width: 20.0,
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Image.asset(
                'assets/logo.png',
                height: 150,
              )
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword(String email) async {
    if (_formKey.currentState!.validate()) {
      await _auth.sendPasswordResetEmail(email: email).then((res) {
        Fluttertoast.showToast(msg: "Please check your email");
        Navigator.pop(context);
      });
    }
  }
}
