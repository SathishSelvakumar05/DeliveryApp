import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Utils/Constants/TextStyles.dart';
import '../CommonFunctions.dart';
import 'CustomTextField.dart';

class SearchableDropdown extends StatefulWidget {
  final GlobalKey dropdownKey;
  final String? selectedValue;
  final String? lableName;
  final ValueChanged<String?> onChanged;

  const SearchableDropdown({
    super.key,
    required this.dropdownKey,
    required this.selectedValue,
    required this.onChanged,
    required this.lableName,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> allOptions = [
    "Single Photo Frame",
    "Wedding Collection",
    "Group Photo Frame",
    "Couple Frame",
    "Baby Kids",
  ];

  List<String> filteredOptions = [];
  String? _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = widget.selectedValue;
    filteredOptions = List.from(allOptions);
    _searchController.addListener(_filterOptions);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  void _filterOptions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredOptions = allOptions
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showDropdown();
    } else {
      _removeDropdown();
    }
  }

  void _showDropdown() {
    final renderBox =
    widget.dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeDropdown,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              width: size.width,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(6.r),
                  color: Colors.white,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 220.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Compact search box
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: 6.w, vertical: 0.h),
                        //   child: TextField(
                        //     controller: _searchController,
                        //     decoration: InputDecoration(
                        //       hintText: 'Search...',
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(6.r),
                        //       ),
                        //       isDense: true,
                        //       contentPadding: EdgeInsets.symmetric(
                        //           vertical: 2.h, horizontal: 10.w),
                        //     ),
                        //     onChanged: (value) => _filterOptions(),
                        //   ),
                        // ),
                        Flexible(
                          child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: filteredOptions.length,
                            itemBuilder: (context, index) {
                              final value = filteredOptions[index];
                              final isSelected = _tempSelected == value;

                              return ListTile(
                                dense: true,
                                title: Text(
                                  value,
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                selected: isSelected,selectedColor:Colors.purple,
                                onTap: () {
                                  setState(() {
                                    _tempSelected = value;
                                  });
                                  widget.onChanged(_tempSelected);
                                  _removeDropdown();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
    _animationController.forward();
  }

  void _removeDropdown() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _searchController.clear();
      filteredOptions = List.from(allOptions);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              capitalizeFirstLetter(widget.lableName!),
              style: TextStyleClass.textSize14( color: Colors.black),
            ),
            SizedBox(
              width: 5.w,
            ),
              Text(
                '*',
                style: TextStyleClass.textSize13(
                  color: Colors.red.shade400,
                ),
              ),
          ],
        ),
        SizedBox(height: 7.h),
        Container(
          key: widget.dropdownKey,
          // height: 45.h,
          child: CustomTextField(
            onTap: _toggleDropdown,
            icon: Icons.school,suffixIcon: IconButton(onPressed: (){}, icon:Icon(Icons.arrow_drop_down)),
            name: 'dropdown',
            readOnly: true,
            placeHolder: _tempSelected ?? 'Select a Type',
            validators: [],
          ),
        ),
      ],
    );
  }
}
