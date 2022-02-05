part of 'pages.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  String fileUrl = "";
  File? file;
  TextEditingController emails = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  User? user = _auth.currentUser;
  Future pickImage() async {
    try {
      final result = await ImagePicker().pickImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.gallery,
      );
      if (result != null) {
        final file = File(result.path);
        final size = file.lengthSync();
        final bytes = await result.readAsBytes();
        final image = await decodeImageFromList(bytes);
        final name = result.name;

        try {
          final reference = firebaseStorage.ref(name);
          await reference.putFile(file);
          final uri = await reference.getDownloadURL();
          Fluttertoast.showToast(msg: "Please Wait!");
          frs.collection("users").doc(user!.uid).update({
            "imageUrl": uri,
          }).then((_) {
            setState(() {
              fileUrl = uri;
            });

            print("success!");
          });
        } finally {
          Fluttertoast.showToast(msg: "Success!");
        }
      }
    } on PlatformException catch (e) {
      print("error $e");
    }
  }

  @override
  void initState() {
    getUserByUid();
    super.initState();
  }

  void getUserByUid() {
    frs.collection("users").doc(user!.uid).get().then((value) {
      print(value.data());
      fileUrl = value.data()!["imageUrl"].toString();
      name.text = value.data()!["firstName"].toString();
      lastname.text = value.data()!["lastName"].toString();
      emails.text = user!.email.toString();
    });
  }

  Widget appBar() {
    return Container(
        margin: EdgeInsets.only(top: 50, right: 10, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profil",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff3381FF),
                    ),
                  ),
                ),
              ],
            ),
            Image.asset('assets/logo.png', height: 50)
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Column(children: [
            appBar(),
            SizedBox(
              height: 50,
            ),
            Container(
              width: 150.0,
              height: 150.0,
              margin: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await pickImage();
                    },
                    child: Align(
                      alignment: Alignment(1.1, -1),
                      child: Container(
                          width: 30.0,
                          height: 30.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.camera,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(color: Colors.white, width: 2),
                          )),
                    ),
                  ),
                ],
              ),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(fileUrl != ""
                        ? fileUrl
                        : "https://diskop.pekanbaru.go.id/assets/vendor/logo/avat.png")),
                border: Border.all(color: Colors.white, width: 5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  hintText: "",
                  labelText: "First Name",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: lastname,
                decoration: InputDecoration(
                  hintText: "",
                  labelText: "Last Name",
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emails,
                enabled: false,
                decoration: InputDecoration(
                  hintText: "",
                  labelText: "Email",
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                ),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff0062FF)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Color(0xff0062FF), width: 2.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    isLoading = true;
                    frs.collection("users").doc(user!.uid).update({
                      "firstName": name.text,
                      "lastName": lastname.text,
                    }).then((_) {
                      print("success!");
                      Fluttertoast.showToast(msg: "Success!");
                      isLoading = false;
                    });
                  },
                  label: Text('Update Profile'),
                  icon: isLoading
                      ? SizedBox(
                          child: CircularProgressIndicator(color: Colors.white),
                          height: 20.0,
                          width: 20.0,
                        )
                      : Icon(Icons.save),
                )),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red, width: 2.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    // Navigator.pop(context);
                    pushNewScreen(context,
                        screen: LoginPage(), withNavBar: false);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                    _auth.signOut();
                  },
                  label: Text('Log out'),
                  icon: Icon(Icons.logout),
                ))
          ])),
    );
  }
}
