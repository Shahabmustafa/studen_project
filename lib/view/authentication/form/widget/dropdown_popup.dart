import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_service_finder/utils/constant/colors.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class CustomMultiSelectDropDown extends StatelessWidget {
  CustomMultiSelectDropDown({
    required this.hint,
    required this.options,
    required this.maxItems,
    required this.disabledOptions,
    required this.dropdownHeight,
    required this.onOptionSelected,
    super.key,
  });
  String hint;
  List<ValueItem<dynamic>> options;
  List<ValueItem<dynamic>> disabledOptions;
  Function(List<ValueItem<dynamic>>)? onOptionSelected;
  int maxItems;
  double dropdownHeight;
  final MultiSelectController _controller = MultiSelectController();
  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown(
      controller: _controller,
      onOptionSelected: onOptionSelected,
      options: options,
      maxItems: maxItems,
      disabledOptions: disabledOptions,
      selectionType: SelectionType.multi,
      selectedOptionTextColor: TColors.primaryColor,
      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
      dropdownHeight: dropdownHeight,
      hint: hint,
      borderColor: TColors.primaryColor,
      borderWidth: 1.5,
      borderRadius: 10,
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: TColors.black,
      ),
      optionTextStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: TColors.black,
      ),
      selectedOptionIcon: Icon(Icons.check_circle,color: TColors.primaryColor,),

    );
  }
}
