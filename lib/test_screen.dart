import 'package:flutter/material.dart';
import 'package:dofromscratch/views/image_view.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:dofromscratch/class/book_titles.dart';

class ImageHtmlParser extends StatefulWidget {
  final double lastLocation;
  final List<BookTitle> titles;
  final String fullHtml;
  final double textSize;

  const ImageHtmlParser({
    Key? key,
    required this.lastLocation,
    required this.titles,
    required this.fullHtml,
    required this.textSize,
  }) : super(key: key);

  @override
  State<ImageHtmlParser> createState() => _ImageHtmlParserState();
}

class _ImageHtmlParserState extends State<ImageHtmlParser> {
  final ScrollController _scrollController = ScrollController();

  double textSize = 16;
  Color backroundColor = const Color.fromARGB(255, 220, 223, 230);
  Color backroundTextColor = Colors.black;

  final List<String> items = [
    'Original',
    'AlexBrush',
    'Bentham',
    'AbhayaLibreRegular',
    'RobotoIt',
  ];
  String selectedValue = 'Original';

  String currentTitle = "";
  String currentPersent = "0";

  bool isFooterVisible = false;
  bool settingScreen = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    double current =
        _scrollController.offset * 100 / _scrollController.position.maxScrollExtent;
    setState(() {
      currentPersent = current.toStringAsFixed(0);
    });
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        thickness: 10,
        thumbVisibility: true,
        radius: const Radius.circular(6),
        interactive: true,
        child: SingleChildScrollView(
          child: Html(
            data: "<div style='font-size: 16px; font-family: 'Origin'; color: #${backroundTextColor.value.toRadixString(16)};'> ${widget.fullHtml} </div>",
             extensions: [
              OnImageTapExtension(
                onImageTap: (src, imgAttributes, element) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(src!)));
                },
              ),
              const TableHtmlExtension(),
              TagWrapExtension(
                tagsToWrap: {"pagebr"},
                builder: (child) {
                  return child;
                },
              ),
            ],
            onLinkTap: (url, _, __) {},
            style: {
              "table": Style(
                backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
              ),
              "tr": Style(
                border: const Border(bottom: BorderSide(color: Colors.grey)),
              ),
              "th": Style(
                backgroundColor: Colors.grey,
              ),
              "td": Style(
                alignment: Alignment.topLeft,
              ),
            },
          ),
        ),
      ),
    );
  }
}
