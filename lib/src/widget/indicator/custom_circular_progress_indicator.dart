import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parsel_flutter/utils/utils.dart';

///CustomCircularProgressIndicator
class CustomCircularProgressIndicator extends StatefulWidget {
  ///CustomCircularProgressIndicator
  CustomCircularProgressIndicator(
      {Key? key, this.backgroundColor, this.isPendingApisCalling = false})
      : super(key: key);

  Color? backgroundColor;
  bool isPendingApisCalling;

  @override
  State<CustomCircularProgressIndicator> createState() =>
      _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: VariableUtilities.screenSize.height,
      width: VariableUtilities.screenSize.width,
      color: widget.backgroundColor ?? ColorUtils.blackColor.withOpacity(0.6),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: ColorUtils.primaryColor,
            ),
            SizedBox(height: 5.h),
            Material(
              color: Colors.transparent,
              child: Text(
                widget.isPendingApisCalling == true
                    ? '${LocaleKeys.working_on_pending_requests.tr()}...'
                    : '${LocaleKeys.loading.tr()}...',
                style: FontUtilities.h15(fontColor: ColorUtils.whiteColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
