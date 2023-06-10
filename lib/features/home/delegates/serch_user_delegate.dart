import 'package:bit_messenger/core/colors.dart';
import 'package:bit_messenger/core/widgets/error_text.dart';
import 'package:bit_messenger/core/widgets/loader.dart';
import 'package:bit_messenger/features/chat/screens/chat_screen.dart';
import 'package:bit_messenger/features/search_user/controller/search_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchUserDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchUserDelegate(this.ref);

  @override
  String get searchFieldLabel => "Enter a Email Address";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.close,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(getUsersByEmailProvider(query)).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                final userData = data[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData!.profileUrl),
                  ),
                  title: Text(
                    userData.name,
                    style: const TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Text(
                    userData.email,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 13,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) {
                        return ChatScreen(
                          name: userData.name,
                          uid: userData.uid,
                        );
                      })),
                    );
                  },
                );
              }),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
