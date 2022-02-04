part of 'pages.dart';

class RoomChat extends StatefulWidget {
  RoomChat({Key? key}) : super(key: key);

  @override
  State<RoomChat> createState() => _RoomChatState();
}

class _RoomChatState extends State<RoomChat> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      _auth.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                onChanged: (value) {
                  setState(() {});
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
        StreamBuilder<List<types.Room>>(
          stream: firebaseChatCore.rooms(),
          initialData: const [],
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: const Text('No users'),
              );
            }

            return Expanded(
              child: ListView.builder(
                // shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final room = snapshot.data![index];

                  return GestureDetector(
                    onTap: () async {
                      if (room.type == types.RoomType.direct) {
                        try {
                          final otherUser = room.users.firstWhere(
                            (u) => u.id != _user!.uid,
                          );
                          _handlePressed(
                              otherUser.imageUrl.toString(),
                              otherUser.firstName.toString(),
                              otherUser.lastName.toString(),
                              context,
                              room);
                        } catch (e) {
                          // Do nothing if other user is not found
                        }
                      }
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
                          _buildAvatar(room.users.firstWhere(
                            (u) => u.id != _user!.uid,
                          )),
                          Text(getUserName(room.users.firstWhere(
                            (u) => u.id != _user!.uid,
                          ))),
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
    );
  }
}
