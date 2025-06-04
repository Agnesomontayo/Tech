import 'package:flutter/material.dart';

class EditableInfoWidget extends StatefulWidget {
  final String label;
  final String initialValue;
  final bool isEditable;
  final TextInputType? keyBoardType;
  final ValueChanged<String> onSave;
  final bool isMultiline;

  const EditableInfoWidget({
    super.key,
    required this.label,
    required this.initialValue,
    required this.isEditable,
    this.keyBoardType,
    required this.onSave,
    this.isMultiline = false,
  });

  @override
  State<EditableInfoWidget> createState() => _EditableInfoWidgetState();
}

class _EditableInfoWidgetState extends State<EditableInfoWidget> {
  late String _currentValue;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    print('initial value ${widget.initialValue}');
    _controller.text = _currentValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

 /* void _toggleEditing() {
    setState(() {
      if (widget.isEditable) {
        _currentValue = _controller.text;
        widget.onSave(_currentValue);
      } else {
        _controller.text = _currentValue;
      }
      widget.isEditable = !widget.isEditable;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final isMultiline = widget.isMultiline;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                widget.isEditable
                    ? TextFormField(
                  controller: _controller,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Champ requis' : null,
                  keyboardType: widget.isMultiline
                      ? TextInputType.multiline
                      : widget.keyBoardType,
                  minLines: widget.isMultiline ? 5 : 1,
                  maxLines: widget.isMultiline ? 5 : 1,
                  scrollPhysics: const BouncingScrollPhysics(),
                  expands: false, // ne pas étendre au parent
                  onSaved: (newValue) {
                    if (newValue != null) {
                      widget.onSave(newValue);
                    }
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8, horizontal: 8),
                  ),
                )
                    : Text(
                  _currentValue,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
         /* IconButton(
            icon: Icon(widget.isEditable ? Icons.check : Icons.edit),
            onPressed: _toggleEditing,
          ),*/
        ],
      ),
    );
  }
}
