import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:NOMNOM/common/main_button_widget.dart';
import 'package:NOMNOM/features/friends/presentation/duel_page/duel_controller.dart';
import 'package:NOMNOM/router/router_context_extension.dart';
import '../../../../../constants/message_type_constants.dart';
import '../../../../../constants/string_constants.dart';
import '../../../../../theme/theme.dart';
import '../../../../../utils/widgets/loader_widget.dart';
import '../../../../recipes/domain/recipe.dart';

class MessagesCard extends StatelessWidget {
  const MessagesCard(this.type, this.check, this.message, this.time,
      {super.key});
  final String type;
  final bool check;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          check ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.7),
          child: Container(
            decoration: BoxDecoration(
                color: type != MessageType.duel
                    ? check
                        ? ThemeColors.main
                        : ThemeColors.greyText
                    : ThemeColors.primary,
                borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: _buildMessageContent(type),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageContent(String type) {
    if (type == MessageType.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: message.substring(4),
          width: 200,
          fit: BoxFit.cover,
        ),
      );
    } else if (type == MessageType.text) {
      return Text(
        '$message\n\n$time',
        style: TextStyles.chatMessageMain.copyWith(color: ThemeColors.white),
      );
    } else {
      return Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return FutureBuilder<Recipe?>(
          future: ref.watch(duelControllerProvider.notifier).getRecipe(message),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Text('Error fetching recipe data');
            } else {
              final recipe = snapshot.data!;

              return Column(
                  children: [
                Text(StringConstants.culinaryDuel,
                    style: TextStyles.secondaryAuthText),
                GestureDetector(
                  onTap: () =>
                      check ? context.pushDetailPage(recipe: recipe) : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: recipe.imageUrl,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Text(recipe.name, style: TextStyles.secondaryAuthText),
                check
                    ? Text(
                        'Duel sent',
                        style: TextStyles.chatMessageMain,
                      )
                    : MainButtonWidget(
                        label: StringConstants.accept,
                        style: TextStyles.mainButton,
                        onPressed: () {
                          context.pushDetailPage(recipe: recipe);
                        },
                        backgorundColor: ThemeColors.main,
                        elevation: 0,
                      )
              ]
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: e,
                          ))
                      .toList());
            }
          },
        );
      });
    }
  }
}
