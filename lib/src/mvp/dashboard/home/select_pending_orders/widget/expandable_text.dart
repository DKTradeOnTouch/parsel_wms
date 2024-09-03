import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:parsel_flutter/utils/utils.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key? key,
    this.trimLines = 2,
  }) : super(key: key);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    TextSpan link = TextSpan(
        text: _readMore ? " ...read more" : " read less",
        style: FontUtilities.h15(fontColor: ColorUtils.primaryColor),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
            text: widget.text,
            style: FontUtilities.h15(fontColor: ColorUtils.color3F3E3E));
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection
              .rtl, //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: ' ...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset)!;
        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            style: FontUtilities.h15(fontColor: ColorUtils.color3F3E3E),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
              text: widget.text,
              style: FontUtilities.h15(fontColor: ColorUtils.color3F3E3E));
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:parsel_flutter/utils/utils.dart';

// class ExpandableText extends StatefulWidget {
//   const ExpandableText(
//     this.text, {
//     Key? key,
//     this.trimLines = 2,
//   }) : super(key: key);

//   final String text;
//   final int trimLines;

//   @override
//   ExpandableTextState createState() => ExpandableTextState();
// }

// class ExpandableTextState extends State<ExpandableText> {
//   bool _readMore = true;
//   void _onTapLink() {
//     setState(() => _readMore = !_readMore);
//   }

//   @override
//   Widget build(BuildContext context) {
//     const colorClickableText = Colors.blue;
//     Icon readMoreIcon = Icon(Icons.keyboard_arrow_down);
//     Icon readLessIcon = Icon(Icons.keyboard_arrow_up);

//     TextSpan link = TextSpan(
//       text: _readMore ? "... " : " ",
//       style: TextStyle(
//         color: colorClickableText,
//       ),
//       recognizer: TapGestureRecognizer()..onTap = _onTapLink,
//     );

//     Widget result = LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         assert(constraints.hasBoundedWidth);
//         final double maxWidth = constraints.maxWidth;

//         // Create a TextSpan with data
//         final text = TextSpan(
//           text: widget.text,
//           style: FontUtilities.h15(fontColor: ColorUtils.color3F3E3E),
//         );

//         // Layout and measure link
//         TextPainter textPainter = TextPainter(
//           text: link,
//           textDirection: TextDirection.rtl,
//           maxLines: widget.trimLines,
//           ellipsis: ' ...',
//         );
//         textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
//         final linkSize = textPainter.size;

//         // Layout and measure text
//         textPainter.text = text;
//         textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
//         final textSize = textPainter.size;

//         // Get the endIndex of data
//         int endIndex;
//         final pos = textPainter.getPositionForOffset(
//           Offset(textSize.width - linkSize.width, textSize.height),
//         );
//         endIndex = textPainter.getOffsetBefore(pos.offset)!;

//         List<InlineSpan> children = [
//           _readMore
//               ? TextSpan(
//                   text: widget.text.substring(0, endIndex),
//                   style: FontUtilities.h15(fontColor: ColorUtils.color3F3E3E),
//                 )
//               : TextSpan(
//                   text: widget.text,
//                   style: FontUtilities.h15(fontColor: ColorUtils.color3F3E3E),
//                 ),
//           WidgetSpan(
//             child: GestureDetector(
//               onTap: _onTapLink,
//               child: _readMore ? readMoreIcon : readLessIcon,
//             ),
//           ),
//         ];

//         return RichText(
//           softWrap: true,
//           overflow: TextOverflow.clip,
//           text: TextSpan(children: children),
//         );
//       },
//     );
//     return result;
//   }
// }
