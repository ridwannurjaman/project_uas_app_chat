part of 'pages.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<types.User> dataContact = [];
  List<types.User> dataSearch = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/cloudbig.png'),
                      fit: BoxFit.fill)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 70, 8, 0),
              child: TextField(
                onChanged: (text) {
                  text = text.toLowerCase();
                  setState(() {
                    dataContact = dataSearch.where((val) {
                      var cariNama = val.firstName.toString().toLowerCase();
                      return cariNama.contains(text);
                    }).toList();
                  });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    hintText: "",
                    fillColor: Colors.white,
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search)),
              ),
            ),
          ],
        ),
        StreamBuilder<List<types.User>>(
          stream: firebaseChatCore.users(),
          initialData: dataContact,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: const Text('No users'),
              );
            } else {
              dataContact = snapshot.data!;
            }

            return Expanded(
              child: ListView.builder(
                // shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: dataContact.length,
                itemBuilder: (context, index) {
                  final user = dataContact[index];

                  return GestureDetector(
                    onTap: () async {
                      final room = await firebaseChatCore.createRoom(user);
                      _handlePressed(
                          user.imageUrl.toString(),
                          user.firstName.toString(),
                          user.lastName.toString(),
                          context,
                          room);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 234, 234, 234),
                            width: 3.0,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.all(9),
                      child: Row(
                        children: [
                          _buildAvatar(user),
                          Text(getUserName(user)),
                          Spacer(),
                          Icon(CupertinoIcons.chat_bubble_text)
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    ));
  }
}
