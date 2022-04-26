import 'package:exon_app/helpers/disable_glow_list_view.dart';
import 'package:exon_app/helpers/phone_num_formatter.dart';
import 'package:exon_app/ui/widgets/common/svg_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exon_app/constants/constants.dart';
import 'package:exon_app/helpers/transformers.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class InputTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? backgroundColor;
  final Widget? icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool? obscureText;
  final bool? isPassword;
  final bool? isPhone;
  final bool? autofocus;

  const InputTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.width = 330,
    this.height = 45,
    this.borderRadius,
    this.backgroundColor = textFieldFillColor,
    this.icon,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.obscureText,
    this.isPassword,
    this.isPhone,
    this.autofocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var phoneNumFormatter = PhoneNumFormatter(
        masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-');
    return SizedBox(
      width: width,
      // height: height,
      child: TextFormField(
        obscureText: obscureText ?? false,
        inputFormatters: isPhone != null && (isPhone ?? false)
            ? [
                phoneNumFormatter,
              ]
            : null,
        autofocus: autofocus ?? true,
        toolbarOptions: const ToolbarOptions(),
        enableSuggestions: !(isPassword ?? false),
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType,
        cursorColor: brightPrimaryColor,
        decoration: InputDecoration(
          suffixIcon: icon,
          contentPadding: EdgeInsets.only(
            left: 10,
            bottom: (height ?? 45) / 2,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 20)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: backgroundColor,
          label: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: deepGrayColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CommentInputTextField extends StatelessWidget {
  final Function() onSendPressed;
  final TextEditingController controller;
  final double width;
  final FocusNode? focusNode;
  const CommentInputTextField({
    Key? key,
    required this.onSendPressed,
    required this.controller,
    required this.width,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        maxLines: null,
        maxLength: 100,
        focusNode: focusNode,
        style: const TextStyle(
          fontSize: 14,
          color: darkPrimaryColor,
        ),
        controller: controller,
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CommentIcon(
                width: 20,
                height: 20,
                color: Color(0xffDBD7EA),
              ),
            ],
          ),
          suffixIcon: Transform.rotate(
            angle: -45 * math.pi / 180,
            child: Material(
              type: MaterialType.circle,
              color: Colors.transparent,
              child: IconButton(
                onPressed: onSendPressed,
                splashRadius: 20,
                icon: const Icon(
                  Icons.send_rounded,
                  color: brightPrimaryColor,
                ),
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            left: 10,
            bottom: 10,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: textFieldFillColor,
          hintText: '댓글을 입력하세요',
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: darkPrimaryColor,
          ),
        ),
      ),
    );
  }
}

class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      final f = NumberFormat("###-#");
      final number =
          int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
            offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return newValue;
    }
  }
}

class NumberInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLength;
  final double? fontSize;
  final double? height;
  final Function(String)? onChanged;
  const NumberInputField({
    Key? key,
    required this.controller,
    this.hintText,
    this.fontSize = 40,
    this.height,
    this.maxLength,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 75,
      width: 95,
      child: TextField(
        onChanged: onChanged,
        onTap: () {
          if (controller.text == '0.0' || controller.text == '0') {
            controller.clear();
          }
        },
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.bottom,
        scrollPadding: EdgeInsets.zero,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        controller: controller,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: brightPrimaryColor,
          fontFamily: 'Manrope',
        ),
        maxLength: maxLength,
        decoration: InputDecoration(
          counter: const SizedBox.shrink(),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: brightPrimaryColor,
            fontFamily: 'Manrope',
          ),
          border: InputBorder.none,
          isCollapsed: true,
        ),
      ),
    );
  }
}

class PrefixLabelTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? unit;
  final void Function(String)? onChanged;

  const PrefixLabelTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.unit,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 330,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: textFieldFillColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => FocusScope.of(context).requestFocus(focusNode),
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, left: 15, right: 10, bottom: 15),
                  child: Text(
                    label,
                    style: const TextStyle(
                      height: 1,
                      color: deepGrayColor,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                  width: 80,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      suffixText: unit,
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      // border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputFieldDisplay extends StatefulWidget {
  final String labelText;
  final String inputText;
  final void Function()? onPressed;
  final bool isToggled;
  final double inputWidgetHeight;
  final Widget inputWidget;
  final bool? keepAlive;

  final TextEditingController? controller;
  final String? suffixText;
  const InputFieldDisplay({
    Key? key,
    required this.labelText,
    required this.inputText,
    required this.onPressed,
    required this.isToggled,
    required this.inputWidgetHeight,
    required this.inputWidget,
    this.controller,
    this.suffixText,
    this.keepAlive = false,
  }) : super(key: key);

  @override
  State<InputFieldDisplay> createState() => _InputFieldDisplayState();
}

class _InputFieldDisplayState extends State<InputFieldDisplay> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    void onEnd() {
      setState(() {
        isOpen = widget.isToggled;
      });
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      onEnd: onEnd,
      width: 330,
      height: widget.isToggled ? widget.inputWidgetHeight + 46.0001 : 46.0001,
      decoration: BoxDecoration(
        color: textFieldFillColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: DisableGlowListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onPressed,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 15),
                    child: Text(
                      widget.labelText,
                      style: const TextStyle(
                        height: 1,
                        color: deepGrayColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      widget.inputText,
                      style: const TextStyle(
                        height: 1,
                        color: clearBlackColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  // widget.inputText == ''
                  //     ? const SizedBox(
                  //         height: 0,
                  //         width: 0,
                  //       )
                  //     : Padding(
                  //         padding: const EdgeInsets.only(
                  //           top: 10,
                  //           bottom: 10,
                  //         ),
                  //         child: Text(
                  //           widget.inputText,
                  //           style: const TextStyle(
                  //             height: 1,
                  //             color: Colors.black,
                  //             fontSize: 15,
                  //           ),
                  //         ),
                  //       ),
                  widget.controller == null
                      ? const SizedBox.shrink()
                      : SizedBox(
                          height: 25,
                          width: 80,
                          child: TextField(
                            controller: widget.controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixText: widget.suffixText,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              // border: InputBorder.none,
                            ),
                          ),
                        ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: widget.isToggled ? 1 / 4 : -1 / 4,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: widget.isToggled
                            ? brightPrimaryColor
                            : deepGrayColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.keepAlive ?? false)
              SizedBox(
                  height: (widget.isToggled || isOpen)
                      ? widget.inputWidgetHeight
                      : 0.0001,
                  child: widget.inputWidget)
            else
              widget.isToggled || isOpen
                  ? widget.inputWidget
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
          ],
        ),
      ),
    );
  }
}

class DatePicker extends StatelessWidget {
  final Function(DateTime) onBirthDateChanged;
  const DatePicker({
    Key? key,
    required this.onBirthDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310,
      height: 300,
      child: CupertinoDatePicker(
        onDateTimeChanged: onBirthDateChanged,
        initialDateTime: DateTime.now(),
        minimumYear: 1900,
        maximumDate: DateTime.now(),
        maximumYear: DateTime.now().year,
        mode: CupertinoDatePickerMode.date,
      ),
    );
  }
}

class GenderPicker extends StatelessWidget {
  final void Function(Gender?) onChanged;
  final Gender? selectedValue;
  const GenderPicker({
    Key? key,
    required this.onChanged,
    required this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 310,
      // height: 120,
      child: Column(
        children: <Widget>[
          ListTile(
            title: const Text(
              '남성',
              style: TextStyle(fontSize: 15),
            ),
            leading: Radio<Gender>(
              value: Gender.male,
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
          ),
          ListTile(
            title: const Text(
              '여성',
              style: TextStyle(fontSize: 15),
            ),
            leading: Radio<Gender>(
              value: Gender.female,
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class NumberInputFieldDisplay extends StatelessWidget {
  final String? hintText;
  final String inputText;
  final int? maxLength;
  final void Function() onTap;
  const NumberInputFieldDisplay({
    Key? key,
    required this.inputText,
    required this.onTap,
    this.hintText,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 70,
          height: 45,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: deepGrayColor,
              ),
            ),
            child: Center(
              child: Text(
                inputText == '' ? hintText ?? '' : inputText,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleInputField extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  const TitleInputField(
      {Key? key, required this.controller, this.hintText = '제목'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: 30,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: 2,
          bottom: 15,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: lightGrayColor, width: 0.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: lightGrayColor,
            width: 0.5,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: lightGrayColor,
            width: 0.5,
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xffAEADAD),
        ),
      ),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: clearBlackColor,
      ),
    );
  }
}

class ContentInputField extends StatelessWidget {
  final TextEditingController controller;
  const ContentInputField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(
          left: 2,
          bottom: 15,
        ),
        border: InputBorder.none,
        constraints: BoxConstraints(
          minHeight: 300,
        ),
        hintText: '내용을 입력하세요',
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          height: 1.3,
          color: Color(0xffAEADAD),
        ),
      ),
      maxLines: null,
      maxLength: 500,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: clearBlackColor,
      ),
    );
  }
}

class MemoInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  const MemoInputField({
    Key? key,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: const InputDecoration(
        filled: true,
        fillColor: mainBackgroundColor,
        contentPadding: EdgeInsets.only(
          left: 10,
          top: 10,
          bottom: 15,
        ),
        border: InputBorder.none,
        constraints: BoxConstraints(
          minHeight: 300,
        ),
        hintText: '메모를 입력해주세요',
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          height: 1.3,
          color: Color(0xffAEADAD),
        ),
      ),
      maxLines: 9,
      maxLength: 300,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: clearBlackColor,
      ),
    );
  }
}

class SearchInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function(String) onFieldSubmitted;
  const SearchInputField({
    Key? key,
    required this.controller,
    required this.onFieldSubmitted,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(
          left: 0,
          // bottom: 15,
        ),
        border: InputBorder.none,
        constraints: BoxConstraints(
          minHeight: 300,
        ),
        hintText: '검색어를 입력해주세요',
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          height: 1.3,
          color: lightGrayColor,
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: clearBlackColor,
      ),
    );
  }
}
