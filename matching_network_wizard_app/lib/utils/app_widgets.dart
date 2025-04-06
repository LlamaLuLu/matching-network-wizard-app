import 'package:flutter/material.dart';
import 'package:matching_network_wizard_app/utils/app_theme.dart';

class AppWidgets {
  //--------------------- BUTTONS ------------------------//
  static Widget appButton(String btnText, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.bg1,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 34),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        btnText,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppTheme.text1,
        ),
      ),
    );
  }

  //--------------------- HEADINGS ------------------------//

  //--------------------- COMPONENTS ------------------------//
  static Widget textField(
      {bool hasSubscript = false,
      required String label,
      required TextEditingController controller,
      String? subscript,
      String? hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 30, vertical: 10), // More balanced padding
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Aligns text & input properly
        children: [
          // label
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.text2,
              ),
              children: [
                TextSpan(text: label),
                if (hasSubscript)
                  WidgetSpan(
                    child: Transform.translate(
                      offset: Offset(0, 4), // move subscript down
                      child: Text(
                        subscript!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.text2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 20), // Spacing between label & input field

          // Text Field
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: (hintText == null || hintText.isEmpty)
                    ? 'Enter value'
                    : hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.text2,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.bg1, // Border color when not focused
                  ),
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.bg1, // Border color when focused
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.text2,
              ),
              keyboardType: TextInputType.number, // Allows numeric input
            ),
          ),
        ],
      ),
    );
  }
}
