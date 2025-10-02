import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_street_path/models/person.model.dart';

class CardPerson extends ConsumerStatefulWidget {
  final Person person;

  const CardPerson({super.key, required this.person});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<CardPerson> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final img =
        widget.person.portrait ?? "https://cdn.futura-sciences.com/sources/images/actu/esperance-vie-chiens-chiot-golden-retriever.jpg";

    return ListTile(
      tileColor: Theme.of(context).colorScheme.surfaceContainer,
      splashColor: Theme.of(context).colorScheme.primary.withAlpha(100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).colorScheme.onSecondary, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover)),
      ),
      title: Text("${widget.person.lastName} ${widget.person.firstName}"),
      subtitle: Text("${widget.person.zone.name} - ${widget.person.activity}"),
      onTap: () {},
    );
  }
}
