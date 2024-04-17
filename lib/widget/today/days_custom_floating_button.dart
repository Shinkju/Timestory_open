import 'package:flutter/material.dart';
import 'package:timestory/common/colors.dart';

class CustomFloatingActionButton extends StatefulWidget {
  final List<PopupMenuItem<String>> menuItems;
  final Function(String?) onMenuItemSelected;

  const CustomFloatingActionButton({
    super.key,
    required this.menuItems,
    required this.onMenuItemSelected,
  });

  @override
  State<CustomFloatingActionButton> createState() => _CustomFloatingActionButtonState();
}

class _CustomFloatingActionButtonState extends State<CustomFloatingActionButton> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isExpanded ? MediaQuery.of(context).size.width * 0.15 : 0.0,
          height: _isExpanded ? widget.menuItems.length * 50.0 : 0.0,
          alignment: Alignment.topRight,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.menuItems.length,
            itemExtent: 50.0,
            itemBuilder: (context, index) {
              final item = widget.menuItems[index];
              return GestureDetector(
                onTap: (){
                  _toggleExpansion();
                  widget.onMenuItemSelected(item.value);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: DEFAULT_COLOR,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(color: Colors.white),
                    child: item.child!,
                  ),
                ),
              );
            },
          ),
        ),
        FloatingActionButton(
          onPressed: _toggleExpansion,
          child: const Icon(Icons.add),
          backgroundColor: DEFAULT_COLOR,
        ),
      ],
    );
  }
}
