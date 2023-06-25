import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/cupertino.dart';
import '../constants/colors.dart';

class SearchWidget extends StatefulWidget {
  final Function(String) onSearch;
  const SearchWidget({super.key, required this.onSearch});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearch);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch() => widget.onSearch(_controller.text);

  @override
  Widget build(BuildContext context) {
    return AnimSearchBar(
      animationDurationInMilli: 150,
      autoFocus: true,
      color: bgColor,
      searchIconColor: greyColor,
      textFieldColor: newPrimaryColor,
      rtl: true,
      width: 250,
      textController: _controller,
      onSuffixTap: () => setState(() => _controller.clear()),
      onSubmitted: (value) => _onSearch(),
    );
  }
}
