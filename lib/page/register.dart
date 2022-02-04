part of 'pages.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController email = new TextEditingController();
  TextEditingController nama = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController repassword = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  bool isLoading = false;
  bool passwordVisible = true;
  bool passwordVisibleType = true;
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
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) => EmailValidator.validate(value!)
                              ? null
                              : "Please enter a valid email",
                          controller: email,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) =>
                              value != null ? null : "Please Enter Your Name",
                          controller: nama,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "Enter Your Name",
                            labelText: "First Name",
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) =>
                              value != null ? null : "Please Enter Your Name",
                          controller: lastname,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "Enter Your Name",
                            labelText: "Lastname",
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) =>
                              value != null ? null : "Please enter password",
                          controller: password,
                          obscureText: passwordVisible ? true : false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: "Password",
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) => value == password.text
                              ? null
                              : "Passwords must be the same",
                          controller: repassword,
                          obscureText: passwordVisibleType ? true : false,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: "Retype your password",
                              labelText: "Retype Password",
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisibleType
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisibleType = !passwordVisibleType;
                                  });
                                },
                              )),
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
                            signUp();
                          },
                          label: Text('SIGN UP'),
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
            ],
          ),
        ),
      ),
    );
  }

  void signUp() {
    _auth
        .createUserWithEmailAndPassword(
            email: email.text, password: password.text)
        .then((result) {
      saveToFireStore();
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  void saveToFireStore() async {
    User? user = _auth.currentUser;
    await firebaseChatCore.createUserInFirestore(
      types.User(
        firstName: nama.text,
        id: user!.uid,
        imageUrl: 'https://diskop.pekanbaru.go.id/assets/vendor/logo/avat.png',
        lastName: lastname.text,
      ),
    );
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HalamanUtama(
                  uid: user.uid,
                )));

    Fluttertoast.showToast(msg: "Account Created Successfully");
  }
}
