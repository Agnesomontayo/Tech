import 'package:flutter/material.dart';

class EditableInfoWidget extends StatefulWidget {
  final String label;
  final String initialValue;
  final TextInputType? keyBoardType;
  final ValueChanged<String> onSave;

  const EditableInfoWidget({
    super.key,
    required this.label,
    required this.initialValue,
    this.keyBoardType,
    required this.onSave,
  });

  @override
  State<EditableInfoWidget> createState() => _EditableInfoWidgetState();
}

class _EditableInfoWidgetState extends State<EditableInfoWidget> {
  late String _currentValue; // La valeur actuelle
  bool _isEditing = false; // Si le champ est en mode édition
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller.text = _currentValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      if (_isEditing) {
        // Sauvegarder le texte modifié
        _currentValue = _controller.text;
        widget.onSave(_currentValue);
      } else {
        // Entrer en mode édition
        _controller.text = _currentValue;
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                _isEditing
                    ? TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 8, horizontal: 8),
                  ),
                  keyboardType: widget.keyBoardType,
                  autofocus: true,
                )
                    : Text(
                  _currentValue,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _toggleEditing,
          ),
        ],
      ),
    );
  }
}
