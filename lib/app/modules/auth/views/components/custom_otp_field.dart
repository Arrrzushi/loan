import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomOtpField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const CustomOtpField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    required this.onChanged,
    this.controller,
  });

  @override
  State<CustomOtpField> createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends State<CustomOtpField> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late String _otpValue;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers =
        List.generate(widget.length, (index) => TextEditingController());
    _otpValue = '';

    // If a controller is provided, use it to prefill the OTP boxes
    if (widget.controller != null) {
      widget.controller!.addListener(_updateFields);
    }
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateFields() {
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      final text = widget.controller!.text;
      for (int i = 0; i < text.length && i < widget.length; i++) {
        _controllers[i].text = text[i];
      }
    }
  }

  void _updateOtpValue() {
    _otpValue = _controllers.map((controller) => controller.text).join();
    widget.onChanged(_otpValue);

    if (_otpValue.length == widget.length) {
      widget.onCompleted(_otpValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        widget.length,
        (index) => SizedBox(
          width: 50,
          height: 60,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            maxLength: 1,
            decoration: InputDecoration(
              counter: const SizedBox.shrink(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFFFF7E1D), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              if (value.isNotEmpty) {
                // Auto-advance to next field
                if (index < widget.length - 1) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              }
              _updateOtpValue();
            },
          ),
        ),
      ),
    );
  }
}
