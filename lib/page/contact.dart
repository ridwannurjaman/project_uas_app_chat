part of 'pages.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  void _handlePressed(types.User otherUser, BuildContext context) async {
    final room = await firebaseChatCore.createRoom(otherUser);

    Navigator.of(context).pop();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }

  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = getUserName(user);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

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
        StreamBuilder<List<types.User>>(
          stream: firebaseChatCore.users(),
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
                  final user = snapshot.data![index];

                  return GestureDetector(
                    onTap: () {
                      _handlePressed(user, context);
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
    ;
  }
}
