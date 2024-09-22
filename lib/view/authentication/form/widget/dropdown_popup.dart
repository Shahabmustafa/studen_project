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
      selectedOptionTextColor: TColors.white, // Change the text color of selected items to white
      chipConfig: ChipConfig(
        wrapType: WrapType.wrap,
        backgroundColor: TColors.primaryColor, // Set the background color of the selected chips
        labelStyle: GoogleFonts.poppins( // Style for the chip text
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: TColors.white, // Set the chip text color to white
        ),
        // borderRadius: BorderRadius.circular(8), // Set the chip border radius
        deleteIconColor: TColors.white, // Change the delete icon color inside the chip
      ),
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
      selectedOptionIcon: Icon(
        Icons.check_circle,
        color: TColors.primaryColor, // Icon color for selected options
      ),
    );
  }
}
